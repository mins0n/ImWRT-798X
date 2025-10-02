# ImmortalWrt-Builder-24.10 🚀

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/hhCodingCat/ImWRT-798X/ImmortalWrt-24.10-6.6固件构建?label=Build%20Status)
![License](https://img.shields.io/github/license/hhCodingCat/ImWRT-798X?color=blue)

这是一个用于自动编译 [ImmortalWrt 24.10](https://github.com/padavanonly/immortalwrt-mt798x-24.10) 固件的 **GitHub Actions 工作流**，专为基于 **MediaTek MT7981** 芯片的设备设计。支持定期检查源码更新、为多种设备型号编译固件，并将固件文件上传至 **GitHub Release** 和 **WebDAV**。通过直观的 **下拉列表** 选择设备型号，操作简单，特别适合 **小白和无经验用户** 快速上手！

---

## ✨ 功能亮点

- **支持的设备** 📡：
  - 中国移动 RAX3000M NAND
  - 中国移动 RAX3000M eMMC
  - Cudy AP3000 AX3000
  - Cudy AP3000 户外版
  - Cudy M3000 AX3000
  - Cudy RE3000 AX3000 中继器
  - Cudy TR3000 AX3000
  - Cudy TR3000 AX3000 256MB
  - Cudy WR3000 AX3000
  - Cudy WR3000S AX3000 增强版
  - GL.iNet Mango AX MT2500
  - GL.iNet Beryl AX MT3000
  - GL.iNet X3000 LTE
  - GL.iNet XE3000 工业级 LTE
  - H3C NX30 Pro 魔术路由器
  - 华思飞 WH3000 Pro
  - 华思飞 WH3000 eMMC
  - JCG Q30 Pro AX3000
  - Livinet ZR3020 AX3000
  - Routerich AX3000
  - Routerich AX3000 V1
  - 小米 AX3000T
  - 小米 WR30U 原厂
  - 红米 AX6000 原厂
  - 合勤 EX5601-T0 原厂
  - 合勤 NWA50AX Pro AP

- **自动编译** ⏰：每周五北京时间 **15:00（UTC 07:00）** 检查源仓库更新，若有新提交，自动为所有支持的设备编译固件。
- **5G 25dB 增强** 📶：支持启用 5G 高功率模式（默认启用，手动编译时可选择是否启用）。
- **固件上传** 📤：编译完成后，上传 `sysupgrade.bin` 和 `factory.bin` 文件至 GitHub Release 和 WebDAV，并附带 README.md 说明文件。
- **清理机制** 🧹：保留最近 **5 个 GitHub Release** 和 **最近 7 天或至少 3 次** 的工作流运行记录，自动删除旧记录以节省空间。
- **功能特性** 💻：
  - 优化网络性能和稳定性
  - 支持安卓 USB 共享上网
  - 支持 USB 网卡和 USB 随身 WiFi
  - MediaTek HNAT 硬件加速
  - Ksmbd 文件共享
  - 默认管理地址：`192.168.2.1`，密码为空
- **小白友好** 🖱️：通过 GitHub Actions 的 **下拉列表** 选择设备型号，无需手动修改配置文件，简单直观，零基础用户也能轻松编译固件！

---

## 🛠️ 使用方法

### 1. 配置仓库
1. Fork 或克隆本仓库到你的 GitHub 账户：[hhCodingCat/ImWRT-798X](https://github.com/hhCodingCat/ImWRT-798X)。
2. 在仓库的 **Settings > Secrets and variables > Actions** 中添加以下 Secrets：
   - `WEBDAV_URL`：WebDAV 服务器地址（例如：`https://dav.example.com/firmware/`）
   - `WEBDAV_USERNAME`：WebDAV 用户名
   - `WEBDAV_PASSWORD`：WebDAV 密码

### 2. 手动触发编译
1. 进入仓库的 **Actions** 页面，选择 `ImmortalWrt-24.10-6.6固件构建` 工作流。
2. 点击 **Run workflow**，通过 **下拉列表** 选择：
   - `device_model`：目标设备型号（直观选择，无需记住复杂代码）
   - `enable_5g_25db`：是否启用 5G 25dB 增强（默认：启用）
   - 可选：自定义 `repo_url` 和 `repo_branch`
3. 点击运行后，固件将自动编译并上传至 GitHub Release 和 WebDAV，适合零基础用户操作。

### 3. 定时触发
- 无需手动操作，工作流每周五北京时间 **15:00（UTC 07:00）** 检查源仓库 [padavanonly/immortalwrt-mt798x-24.10](https://github.com/padavanonly/immortalwrt-mt798x-24.10) 的 `openwrt-24.10-6.6` 分支。
- 如果检测到更新，自动为所有支持的设备型号编译固件并上传。

### 4. 下载固件
- **GitHub Release** 📦：在仓库的 **Releases** 页面查找标签（如 `ImmortalWrt-24.10-<device_code>-<version>`），下载 `sysupgrade.bin`、`factory.bin` 和 `README.md`。
- **WebDAV** ☁️：通过配置的 WebDAV 服务器访问固件，文件名为 `<device_code>_25dB-on_<version>_<type>.bin`。

### 5. 刷写固件
1. 确认设备型号与固件匹配。
2. 备份设备原有配置。
3. 使用 Web 界面或 SSH 刷入：
   - `sysupgrade.bin`（保留配置）
   - `factory.bin`（全新安装）
4. 确保升级过程中电源稳定，避免中断。

---

## ⚠️ 注意事项
- **风险提示**：刷写固件可能导致设备变砖，请谨慎操作，确保固件与设备型号完全匹配。
- **WebDAV 配置**：确保 WebDAV 服务器可访问，且 Secrets 配置正确，否则上传可能失败。
- **编译时间**：单设备编译可能需要 **1-2 小时**，视 GitHub Actions 资源而定。
- **5G 25dB 增强**：高功率模式可能受当地法规限制，请确认合法性后再使用。
- **管理地址**：固件默认 IP 为 `192.168.2.1`，密码为空，升级后建议检查网络设置。

---

## 📚 源码
- 本工作流基于 [padavanonly/immortalwrt-mt798x-24.10](https://github.com/padavanonly/immortalwrt-mt798x-24.10)。
- 分支：`openwrt-24.10-6.6`。
- 仓库：[hhCodingCat/ImWRT-798X](https://github.com/hhCodingCat/ImWRT-798X)。

---

## 🙏 致谢
特别感谢以下作者和贡献者：
- **[P3TERX](https://p3terx.com)**：提供了 `diy-part1.sh` 和 `diy-part2.sh` 脚本的初始框架，为本项目的自动化构建提供了重要支持。
- **[padavanonly](https://github.com/padavanonly)**：维护了 ImmortalWrt MT798x 24.10 源代码仓库，为本项目提供了核心固件源码。
- **ImmortalWrt 社区**：感谢社区开发者的持续努力，确保了固件的性能优化与功能完善。

---

## 🤝 贡献
欢迎提交 **Issue** 或 **Pull Request**，优化工作流或添加新功能！让我们一起完善这个项目！

---

## 📄 许可证
本项目遵循 **MIT 许可证**，详情见 [LICENSE](LICENSE)。
