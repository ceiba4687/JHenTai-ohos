<img src="./android/app/src/main/res/mipmap-xxhdpi/ic_launcher_round.png" alt="JHenTai-ohos logo" width="144" height="144" align="right" />

# JHenTai-ohos

[JHenTai](https://github.com/jiangtian616/JHenTai) 的 HarmonyOS / OpenHarmony 移植版。

本仓库专注于原生 HarmonyOS HAP 构建；Android、iOS、Windows、macOS 和 Linux
版本请前往[上游项目](https://github.com/jiangtian616/JHenTai)。

## 下载

从 [GitHub Releases](https://github.com/ceiba4687/JHenTai-ohos/releases) 下载最新的
`JHenTai-ohos-*-unsigned.hap`。

Release 仅提供未签名 HAP。安装前需要使用安装者自己的 HarmonyOS 证书完成签名；
仓库和 Release 不分发签名证书或私钥。

- 目标系统：HarmonyOS 7 / API 26
- 最低兼容版本：HarmonyOS 5.1 / API 18
- 发布架构：`ohos-arm64`
- 应用显示名：`JHenTai`
- Bundle ID：`top.jtmonster.jhentai.ohos`

鸿蒙版使用独立 Bundle ID，可与卓易通中的 Android 版 JHenTai 同时安装。

## 当前状态

已在 HarmonyOS 7 / API 26 模拟器及真机上验证：

- 应用启动、数据库初始化与基础设置
- E-Hentai / EXHentai 登录及画廊浏览
- 域名前置、系统代理与应用内代理配置
- 在线阅读、音量键翻页、下载及离线阅读
- 收藏、历史记录与下载进度持久化
- 系统分享与图片保存到图库
- 本地画廊路径选择器启动及生物识别能力检测

平台差异及尚需真机覆盖的边界场景见
[HarmonyOS 开发说明](./docs/ohos.md#platform-limitations)。

## 编译

### 环境

- DevEco Studio 及 HarmonyOS 7 / API 26 SDK
- [CPF-Flutter](https://gitcode.com/CPF-Flutter/flutter_flutter)
  `3.44.9+ohos-0.0.1-canary1`
- PowerShell 7（推荐）

默认工具路径和可覆盖的环境变量记录在
[docs/ohos.md](./docs/ohos.md)。

### 命令

```powershell
git clone https://github.com/ceiba4687/JHenTai-ohos.git
Set-Location JHenTai-ohos

.\tool\flutter-ohos.ps1 doctor -v
.\tool\flutter-ohos.ps1 pub get
.\tool\flutter-ohos.ps1 analyze --no-pub
.\tool\flutter-ohos.ps1 test --no-pub
.\tool\build-ohos.ps1 -Mode release -NoCodesign
```

若 GitHub 依赖下载较慢，可仅为当前终端配置代理：

```powershell
$env:JHENTAI_GIT_PROXY = 'http://127.0.0.1:4787'
.\tool\flutter-ohos.ps1 pub get
```

可安装的 HAP 需要由安装者在 DevEco Studio 中配置签名。详细工具链、插件来源、签名和
设备验证信息见 [HarmonyOS 开发说明](./docs/ohos.md)。

## 致谢

- [jiangtian616/JHenTai](https://github.com/jiangtian616/JHenTai) 及其贡献者
- [CPF-Flutter](https://gitcode.com/CPF-Flutter/flutter_flutter) 鸿蒙 Flutter 适配
- [bgli100/pixez-flutter-ohos](https://github.com/bgli100/pixez-flutter-ohos) 的移植与发布结构参考

## 许可证

本项目继承上游项目的 [Apache License 2.0](./LICENSE)。
