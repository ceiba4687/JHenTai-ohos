# OHOS compatibility patch

This is `flex_color_picker` 3.1.0 from pub.dev, vendored under its original
license. The only source change adds fallback results for platforms added to
Flutter's `TargetPlatform` enum, including OHOS.

Upstream 3.8.0 still lacks these fallbacks as of 2026-08-31, so upgrading does
not resolve the HarmonyOS kernel compilation failure.
