import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HarmonyOS uses a bundle name distinct from Android', () {
    final appConfig =
        jsonDecode(File('ohos/AppScope/app.json5').readAsStringSync())
            as Map<String, dynamic>;
    final app = appConfig['app'] as Map<String, dynamic>;

    expect(app['bundleName'], 'top.jtmonster.jhentai.ohos');
    expect(app['bundleName'], isNot('top.jtmonster.jhentai'));
  });
}
