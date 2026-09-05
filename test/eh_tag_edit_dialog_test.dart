import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jhentai/src/database/database.dart';
import 'package:jhentai/src/model/tag_set.dart';
import 'package:jhentai/src/widget/eh_tag_edit_dialog.dart';

void main() {
  tearDown(Get.reset);

  WatchedTag createTag() => WatchedTag(
        tagId: 1,
        tagData: const TagData(namespace: 'language', key: 'english'),
        watched: true,
        hidden: false,
        weight: 10,
        backgroundColor: Colors.red,
      );

  Future<void> openEditor(
    WidgetTester tester, {
    required WatchedTag tag,
    required bool isDialog,
    OnTagEdited? onConfirm,
  }) async {
    await tester.pumpWidget(GetMaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return TextButton(
            onPressed: () {
              final editor = EHTagEditDialog(
                tag: tag,
                isDialog: isDialog,
                onConfirm: onConfirm,
              );
              if (isDialog) {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(child: editor),
                );
              } else {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => editor,
                );
              }
            },
            child: const Text('open'),
          );
        }),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('OHOS custom color reset is staged until confirmation',
      (tester) async {
    final tag = createTag();
    WatchedTag? savedTag;
    await openEditor(tester,
        tag: tag,
        isDialog: false,
        onConfirm: (_, updated) => savedTag = updated);

    await tester.tap(find.text('custom'));
    await tester.pumpAndSettle();
    expect(find.byType(EHTagColorSettingDialog), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('reset'));
    await tester.pumpAndSettle();
    expect(savedTag, isNull);
    expect(tag.backgroundColor, Colors.red);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull);

    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();
    expect(savedTag, isNotNull);
    expect(savedTag!.backgroundColor, isNull);
    expect(savedTag!.weight, 10);
    expect(savedTag!.watched, isTrue);
    expect(tag.backgroundColor, Colors.red);
  }, variant: const TargetPlatformVariant({TargetPlatform.ohos}));

  for (final isDialog in [false, true]) {
    testWidgets('OHOS editor stays usable in landscape (dialog: $isDialog)',
        (tester) async {
      tester.view.physicalSize = const Size(700, 320);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      WatchedTag? savedTag;
      await openEditor(tester,
          tag: createTag(),
          isDialog: isDialog,
          onConfirm: (_, updated) => savedTag = updated);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.text('hidden'));
      await tester.tap(find.text('hidden'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.widgetWithText(FilledButton, 'OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'OK'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(savedTag, isNotNull);
      expect(savedTag!.watched, isFalse);
      expect(savedTag!.hidden, isTrue);
    }, variant: const TargetPlatformVariant({TargetPlatform.ohos}));
  }
}
