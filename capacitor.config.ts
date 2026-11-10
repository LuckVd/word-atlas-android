import type { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "io.wordatlas.app",
  appName: "词光",
  webDir: "www",
  android: {
    // 词光暗色主题底色（与 index.html theme-color 一致），用作启动背景
    backgroundColor: "#0D1120",
    // WebView 内使用 https scheme 服务本地资产，localStorage 等按 https 源工作
    allowMixedContent: false,
  },
  // 说明：Android WebView 不支持 Service Worker，www/sw.js 的注册会静默失败，
  // 无碍——全部资产已随 APK 离线打包，不依赖 SW 缓存。
};

export default config;
