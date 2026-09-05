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
  }, variant: const TargetPlatformVariant({TargetPlatform.ohos}));

  testWidgets('cache durations reflect changes immediately', (tester) async {
    final initialPageAge = networkSetting.pageCacheMaxAge.value;
    final initialImageAge = networkSetting.cacheImageExpireDuration.value;
    addTearDown(() {
      networkSetting.pageCacheMaxAge.value = initialPageAge;
      networkSetting.cacheImageExpireDuration.value = initialImageAge;
    });
    networkSetting.pageCacheMaxAge.value = const Duration(minutes: 1);
    networkSetting.cacheImageExpireDuration.value = const Duration(days: 1);

    await tester.pumpWidget(GetMaterialApp(home: SettingNetworkPage()));
    final dropdowns = find.byType(DropdownButton<Duration>);
    expect(tester.widget<DropdownButton<Duration>>(dropdowns.at(0)).value,
        const Duration(minutes: 1));
    expect(tester.widget<DropdownButton<Duration>>(dropdowns.at(1)).value,
        const Duration(days: 1));

    networkSetting.pageCacheMaxAge.value = const Duration(days: 3);
    networkSetting.cacheImageExpireDuration.value = const Duration(days: 30);
    await tester.pump();

    expect(tester.widget<DropdownButton<Duration>>(dropdowns.at(0)).value,
        const Duration(days: 3));
    expect(tester.widget<DropdownButton<Duration>>(dropdowns.at(1)).value,
        const Duration(days: 30));
  }, variant: const TargetPlatformVariant({TargetPlatform.ohos}));
}
