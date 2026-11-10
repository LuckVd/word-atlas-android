# word-atlas-android

词光 Word Atlas 的非官方安卓封装（Capacitor 8 WebView 壳），**完全离线、零权限**：Web 构建产物 + 712MB 官方开源词库（7,298 词条插画/真人发音）全部打进 APK，不联网、不申请任何 Android 权限。

> 上游项目：[designfuchen/word-atlas](https://github.com/designfuchen/word-atlas)（代码 MIT / 词库 CC BY 4.0）。本仓库不包含上游代码与词库数据，只提供打包壳；词库内容未修改。许可与署名见 [开源许可](#开源许可与合规) 及 APK 内 `LICENSES.html`。

## 安装

从 [Releases](../../releases) 下载最新 APK（约 640MB），手机直接安装（Android 7.0+，需允许"未知来源"）。安装约需 1.5GB 空闲空间。完全离线可用，进度存手机本地。

## 从源码构建

前置：Node.js 20+、JDK 21、Android SDK（platform 36）。

```bash
# 1) 准备上游 Web 构建
git clone https://github.com/designfuchen/word-atlas ../word-atlas
cd ../word-atlas && npm ci && npm run build && cd -

# 2) 安装壳依赖并同步资产（www/ 约 717MB，含 LICENSES.html）
npm ci
./sync-www.sh

# 3) 生成/更新 android 工程内容（首次 cap add，之后 cap sync）
npx cap add android     # 仅首次；仓库已含 android/ 时跳过
npx cap sync android

# 4) 配置自己的签名（signing.properties 不入库）
keytool -genkeypair -v -keystore wordatlas-release.keystore -alias wordatlas \
  -keyalg RSA -keysize 2048 -validity 10950 -dname "CN=Your Name"
cat > signing.properties <<'EOF'
WORDATLAS_STORE_FILE=../wordatlas-release.keystore
WORDATLAS_STORE_PASSWORD=你的密码
WORDATLAS_KEY_ALIAS=wordatlas
WORDATLAS_KEY_PASSWORD=你的密码
EOF

# 5) 打包
cd android && ./gradlew assembleRelease
# 产物：android/app/build/outputs/apk/release/app-release.apk
```

每次上游更新后：`git -C ../word-atlas pull && npm run build` → `./sync-www.sh` → `npx cap sync android` → `./gradlew assembleRelease`。

## 关键配置

| 项 | 值 |
|---|---|
| appId | `io.wordatlas.app` |
| 名称 | 词光 |
| minSdk / targetSdk | 24 (Android 7.0) / 36 |
| 权限 | **无**（AndroidManifest 未声明任何权限，含 INTERNET） |
| 签名 | `signing.properties` 参数化，凭据不入库 |

## 设计说明

- **加载方式**：Capacitor 的 WebViewAssetLoader 把 `assets/public/` 映射为 `https://localhost`，上游 Web 代码零修改（fetch/localStorage/hash 路由均按标准 https 源工作）——与社区 fork 的 `file://` 路线相比，上游更新零分叉成本；
- **无 Service Worker**：Android WebView 不支持 SW，`sw.js` 注册自带 catch 静默失败，资产本来就在本地；
- **进度存储**：WebView localStorage（应用私有目录），卸载即清；跨设备迁移用词光自带的进度导出/导入；
- **图标**：`assets/logo.png`（源自上游 `public/icon-512.png`）经 `npx capacitor-assets generate --android` 生成。

## 开源许可与合规

- 本仓库封装代码：MIT；
- 上游词光：代码 [MIT](https://github.com/designfuchen/word-atlas/blob/main/LICENSE)（© Word Atlas contributors），词库/插画/录音 [CC BY 4.0](https://github.com/designfuchen/word-atlas/blob/main/CONTENT_LICENSE.md)——本分发**未修改内容**，署名 `Word Atlas contributors — CC BY 4.0`；
- Fraunces 字体：SIL OFL 1.1；
- 本应用为非官方封装，与上游作者无隶属关系、不代表官方背书；非官方雅思词表；
- 上述声明同时随 APK 内 `LICENSES.html` 分发。

## 已知差异（相对上游网页版 / iOS 版）

- 例句无发音（上游开源词库不含例句录音；需要 TTS 可自行在 Capacitor 桥接 sherpa-onnx）；
- 无复习提醒通知、桌面小部件（可经 Capacitor 插件扩展）。
