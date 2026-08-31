import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jhentai/src/pages/setting/network/setting_network_page.dart';
import 'package:jhentai/src/setting/network_setting.dart';

void main() {
  testWidgets('domain fronting switch reflects changes immediately',
      (tester) async {
    final initialValue = networkSetting.enableDomainFronting.value;
    addTearDown(() => networkSetting.enableDomainFronting.value = initialValue);
    networkSetting.enableDomainFronting.value = false;

    await tester.pumpWidget(GetMaterialApp(home: SettingNetworkPage()));

    expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        isFalse);

    networkSetting.enableDomainFronting.value = true;
    await tester.pump();

    expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        isTrue);
  });
}
