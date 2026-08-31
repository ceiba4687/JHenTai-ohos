import 'package:flutter/foundation.dart';

abstract final class JPlatform {
  static bool get isOhos => defaultTargetPlatform.name == 'ohos';

  static bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      isOhos;

  static bool get supportsImageClipboard => !isOhos;

  static bool get supportsScreenBrightness => isMobile && !isOhos;
}
