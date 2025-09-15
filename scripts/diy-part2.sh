#!/bin/bash
#
# 版权所有 (c) 2019-2020 P3TERX <https://p3terx.com>
#
# 这是一个自由软件，根据 MIT 许可证授权。
# 详细信息请参见 /LICENSE。
#
# https://github.com/P3TERX/Actions-OpenWrt

# 修改默认 IP
CONFIG_FILE="package/base-files/files/bin/config_generate"
if [ -f "$CONFIG_FILE" ]; then
  if ! grep -q "192.168.2.1" "$CONFIG_FILE"; then
    sed -i 's/192\.168\.6\.1/192.168.2.1/g; s/192\.168\.1\.1/192.168.2.1/g' "$CONFIG_FILE"
    echo "IP 地址已更新为 192.168.2.1"
  else
    echo "IP 地址已是 192.168.2.1，无需修改"
  fi
else
  echo "警告：$CONFIG_FILE 不存在，跳过 IP 修改"
fi

# 预装 OpenClash（已注释，保持不变）
# echo "CONFIG_PACKAGE_luci-app-openclash=y" >> .config

# 删除 package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/e2p
rm -f package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/e2p
if [ $? -eq 0 ]; then
  echo "已删除 package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/e2p"
else
  echo "错误：删除 package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/e2p 失败"
fi

# 创建 MT7981 固件符号链接
EEPROM_FILE="package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin"
if [ -f "$EEPROM_FILE" ]; then
  mkdir -p files/lib/firmware
  ln -sf /lib/firmware/MT7981_iPAiLNA_EEPROM.bin files/lib/firmware/e2p
  echo "符号链接已创建"
  ls -l files/lib/firmware/e2p || { echo "错误：符号链接创建失败"; exit 1; }
else
  echo "错误：$EEPROM_FILE 不存在，无法创建符号链接"
  exit 1
fi

# 修改 5G 25dB EEPROM（仅当 ENABLE_5G_25DB 为 true 时执行）
if [ "$ENABLE_5G_25DB" == "true" ]; then
  echo "启用 5G 25dB EEPROM 修改"
  OFFSET=$((0x445))   # 十六进制 0x445 = 十进制 1093
  PATCH_BYTES='\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B\x2B'
  PATCH_LEN=20

  echo "当前目录: $(pwd)"
  ls -lh package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/ || true

  if [ ! -f "$EEPROM_FILE" ]; then
    echo "错误：未找到 EEPROM 文件: $EEPROM_FILE" >&2
    echo "尝试查找所有位置："
    find . -name MT7981_iPAiLNA_EEPROM.bin || true
    exit 1
  fi

  if [ "$(echo -n -e "$PATCH_BYTES" | wc -c)" -ne "$PATCH_LEN" ]; then
    echo "错误：PATCH_BYTES 长度不匹配，预期 $PATCH_LEN 字节，实际 $(echo -n -e "$PATCH_BYTES" | wc -c) 字节" >&2
    exit 2
  fi

  CURRENT_CONTENT=$(dd if="$EEPROM_FILE" bs=1 skip=$OFFSET count=$PATCH_LEN 2>/dev/null | hexdump -v -e '/1 "\\x%02X"')
  TARGET_CONTENT=$(echo -n -e "$PATCH_BYTES" | hexdump -v -e '/1 "\\x%02X"')

  if [ "$CURRENT_CONTENT" != "$TARGET_CONTENT" ]; then
    echo -n -e "$PATCH_BYTES" | dd of="$EEPROM_FILE" bs=1 seek=$OFFSET count=$PATCH_LEN conv=notrunc status=none
    echo "EEPROM 文件已更新: $EEPROM_FILE"
  else
    echo "EEPROM 文件无需修改: $EEPROM_FILE"
  fi
else
  echo "5G 25dB EEPROM 修改未启用"
fi
