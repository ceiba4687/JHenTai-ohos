import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jhentai/src/utils/eh_spider_parser.dart';
import 'package:jhentai/src/utils/version_util.dart';

void main() {
  group('HarmonyOS version comparison', () {
    test('legacy installed versions equal the first OHOS revision', () {
      expect(compareVersion('8.0.14+332', 'v8.0.14-ohos.1'), 0);
      expect(compareVersion('v8.0.16', '8.0.16-ohos.1+333'), 0);
    });

    test('same-upstream port updates are ordered numerically', () {
      expect(compareVersion('8.0.16', 'v8.0.16-ohos.2'), lessThan(0));
      expect(compareVersion('8.0.16-ohos.2', 'v8.0.16-ohos.2'), 0);
      expect(
          compareVersion('8.0.16-ohos.10', 'v8.0.16-ohos.2'), greaterThan(0));
    });

    test('upstream version takes precedence over port revision', () {
      expect(compareVersion('8.0.16', 'v8.0.14-ohos.10'), greaterThan(0));
      expect(compareVersion('8.0.16-ohos.9', 'v8.0.17-ohos.1'), lessThan(0));
      expect(compareVersion('8.0.9', 'v8.0.10'), lessThan(0));
    });

    test('unsupported version formats are rejected', () {
      for (final version in [
        'v8.0',
        'v8.0.16-beta.1',
        'v8.0.16-ohos.x',
        'latest'
      ]) {
        expect(isValidAppVersion(version), isFalse);
        expect(() => compareVersion('8.0.16', version), throwsFormatException);
      }
    });
  });

  Map<String, dynamic> release(
    String tag, {
    bool draft = false,
    bool prerelease = false,
    String asset = 'JHenTai-ohos-unsigned.hap',
  }) =>
      {
        'tag_name': tag,
        'draft': draft,
        'prerelease': prerelease,
        'assets': [
          {'name': asset}
        ],
      };

  String? latest(List<dynamic> releases) =>
      EHSpiderParser.githubReleasePage2LatestVersion(Headers(), releases);

  group('HarmonyOS release selection', () {
    test('recognizes the existing repository release tag', () {
      expect(latest([release('v8.0.14-ohos.1')]), 'v8.0.14-ohos.1');
    });

    test('chooses highest installable version regardless of API order', () {
      expect(
        latest([
          release('v8.0.15-ohos.9'),
          release('v8.0.16-ohos.10'),
          release('v8.0.16-ohos.2'),
        ]),
        'v8.0.16-ohos.10',
      );
    });

    test('skips drafts, prereleases, malformed tags and non-HAP releases', () {
      expect(
        latest([
          release('v9.0.0-ohos.1', draft: true),
          release('v8.1.0-ohos.1', prerelease: true),
          release('v8.0.99', asset: 'app.apk'),
          release('v8.0.17-ohos.invalid'),
          release('v8.0.16-ohos.1'),
          null,
          {'tag_name': null},
        ]),
        'v8.0.16-ohos.1',
      );
    });

    test('no eligible release is a normal no-update result', () {
      expect(latest([]), isNull);
      expect(latest([release('v8.0.16-ohos.1', prerelease: true)]), isNull);
      expect(
          latest([
            {'tag_name': 'v8.0.16-ohos.1'}
          ]),
          isNull);
    });
  });
}
