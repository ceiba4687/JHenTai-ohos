# JHenTai-ohos development

JHenTai-ohos uses the CPF-Flutter SDK for HarmonyOS builds. The regular Flutter SDK
remains available for Android, iOS, and desktop development. The HarmonyOS
wrapper only changes environment variables for its own process and does not
replace the system Flutter installation.

## Pinned toolchain

- Flutter OH: `3.44.9+ohos-0.0.1-canary1`
- Framework revision: `39285df71a97ffe0c23241dcc459d997a9d8b7c6`
- Dart: `3.12.2`
- DevEco command-line tools: `26.0.0.821`
- HarmonyOS SDK: `26.0.0.105` Release
- Target: HarmonyOS 7 / API 26 (`targetSdkVersion: 26.0.0`)
- Minimum compatible SDK: `5.1.0(18)`
- Default Flutter OH location:
  `C:\devlope\flutter-ohos\3.44.9+ohos-0.0.1-canary1`

The 3.44 Canary tag is required because current JHenTai dependencies require
Dart 3.12. The latest stable Flutter OH 3.41 release only includes Dart 3.11.
The SDK is pinned to a tag and must not be upgraded with `flutter upgrade`.

## Commands

Run all HarmonyOS Flutter commands through the project wrapper:

```powershell
.\tool\flutter-ohos.ps1 doctor -v
.\tool\flutter-ohos.ps1 pub get
.\tool\flutter-ohos.ps1 analyze --no-pub
.\tool\flutter-ohos.ps1 test --no-pub
.\tool\build-ohos.ps1 -Mode debug -NoCodesign
```

The app entry point is `lib/src/main.dart`; do not use Flutter's default
`lib/main.dart` target.

For slow GitHub dependencies, set the proxy only for the current terminal:

```powershell
$env:JHENTAI_GIT_PROXY = 'http://127.0.0.1:4787'
.\tool\flutter-ohos.ps1 pub get
```

The wrapper accepts these optional path overrides:

- `JHENTAI_FLUTTER_OHOS_HOME`
- `JHENTAI_DEVECO_TOOL_HOME`
- `JHENTAI_JAVA_HOME`

## Signing

Unsigned HAP builds are sufficient for compile checks. To run on a device,
open the `ohos` directory in DevEco Studio, then configure an automatic or
release signature under `File > Project Structure > Signing Configs`.

Build output is written to `build/ohos/hap`. The default device architecture
is `ohos-arm64`; use `ohos-x64` for a Windows x64 emulator.

## Plugin policy

HarmonyOS plugin ports are sourced from the official CPF-Flutter repositories
and pinned in `pubspec.yaml`. A package that is not listed in the generated
`.flutter-plugins-dependencies` `ohos` section has no native HarmonyOS
implementation and must not be assumed to work at runtime.

The current build registers these 19 OHOS plugins:

```text
audio_session
battery_plus
device_info_plus
file_picker_ohos
fluttertoast
http_proxy
just_audio_ohos
local_auth_ohos
package_info_plus
path_provider_ohos
permission_handler_ohos
receive_sharing_intent
saver_gallery
share_plus
sqflite_ohos
sqlite3_flutter_libs
url_launcher_ohos
wakelock_plus_ohos
webview_flutter_ohos
```

The app declares Internet and biometric permissions. Its entry ability accepts
HarmonyOS share intents so gallery URLs and image-page URLs can be opened from
other apps. Saving images uses the HarmonyOS asset-creation dialog supplied by
`saver_gallery`; it does not request Android storage permissions.

## Platform limitations

- `screen_brightness` has no OHOS implementation. Custom reader brightness is
  hidden on HarmonyOS; keep-screen-awake remains available through
  `wakelock_plus_ohos`.
- `pasteboard` has no OHOS image implementation. Image-copy actions are hidden;
  system sharing and saving to the gallery remain available.
- The DevEco API 26 emulator cannot complete the external URL callback,
  rotation, or first-time IME flow reliably because its system UI/graphics
  process exits. Verify these workflows on physical hardware.
- The system document picker opens correctly, but automated emulator input
  cannot return exactly one extra gallery directory. Verify the single-folder
  result on a physical device.
- Biometric authentication and headset/audio-route behavior require matching
  physical hardware.
- The checked HAP is unsigned. Device deployment requires a DevEco signing
  configuration.
- Compile and unit-test verification do not replace device testing of database,
  WebView, authentication, sharing, and media workflows.

## Verified output

The unsigned debug build is produced at:

```text
build\ohos\hap\entry-default-unsigned.hap
```

Inspecting the packaged `module.json` should report bundle
`top.jtmonster.jhentai.ohos`, version `8.0.14` (`332`), compile SDK
`26.0.0.105`, target API 26, and minimum API 18.

The HarmonyOS bundle name intentionally has the `.ohos` suffix. The Android
application keeps `top.jtmonster.jhentai`, allowing the native HarmonyOS build
and the Android build in ZhuoyiTong to be installed at the same time.

## Emulator verification

The debug app has been built, signed through DevEco Studio, installed, and
launched on an `ohos-x64` emulator running HarmonyOS 7.0.0 / API 26. Startup,
database initialization, update checks, plugin registration, and the tag
translation database completed without a Flutter platform exception. The same
build was also launched successfully on an OpenHarmony 6.1.1 / API 24 emulator,
confirming compatibility above the configured minimum API 18.

The `ohos-arm64` debug build has also been installed and launched on a Huawei
SGT-AL10 physical device running HarmonyOS 7.0.0 / API 26. The device reported
the independent `top.jtmonster.jhentai.ohos` bundle, an arm64 native library
path, successful service and database initialization, and no unhandled Flutter
exception during startup.

The Dart `sqlite3` package does not recognize OHOS as a built-in platform.
JHenTai therefore overrides its library resolver on OHOS and loads
`libsqlite3.so`, which is packaged by `sqlite3_flutter_libs`.

Domain fronting has been verified on the API 26 emulator: after enabling
`Bypass SNI blocking`, gallery browsing succeeds. The emulator cannot use the
Windows host proxy through `127.0.0.1`; configure it with a host-reachable
address when an endpoint requires the local proxy.

Volume-key page turning uses the HarmonyOS InputKit `inputConsumer` API. The
listener is active only while the reader requests it, and consumes volume-up
and volume-down events so the system volume does not change while turning
pages.
