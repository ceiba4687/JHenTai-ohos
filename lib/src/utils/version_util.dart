final RegExp _versionPattern = RegExp(r'^v?(\d+)\.(\d+)\.(\d+)(?:-ohos\.([1-9]\d*))?(?:\+\d+)?$');

bool isValidAppVersion(String version) => _versionPattern.hasMatch(version.trim());

/// Compares release tags and PackageInfo versions, ignoring build metadata.
/// Legacy versions without an OHOS suffix represent the first port revision.
int compareVersion(String a, String b) {
  List<int> numberA = _versionNumbers(a);
  List<int> numberB = _versionNumbers(b);

  for (int i = 0; i < numberA.length; i++) {
    int comparison = numberA[i].compareTo(numberB[i]);
    if (comparison != 0) {
      return comparison;
    }
  }

  return 0;
}

List<int> _versionNumbers(String version) {
  RegExpMatch? match = _versionPattern.firstMatch(version.trim());
  if (match == null) {
    throw FormatException('Invalid app version', version);
  }
  return [
    int.parse(match[1]!),
    int.parse(match[2]!),
    int.parse(match[3]!),
    int.parse(match[4] ?? '1'),
  ];
}
