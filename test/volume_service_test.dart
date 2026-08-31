import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jhentai/src/service/volume_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel(
    'top.jtmonster.jhentai.volume.event.intercept',
  );
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.ohos;
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('HarmonyOS volume events are forwarded while listening', () async {
    final interceptionStates = <bool>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'set');
      interceptionStates.add(call.arguments as bool);
      return null;
    });

    final events = <VolumeEventType>[];
    final service = VolumeService();
    await service.doAfterBeanReady();
    await service.listen(events.add);

    await messenger.handlePlatformMessage(
      channel.name,
      const StandardMethodCodec().encodeMethodCall(
        const MethodCall('event', 1),
      ),
      (ByteData? _) {},
    );
    await messenger.handlePlatformMessage(
      channel.name,
      const StandardMethodCodec().encodeMethodCall(
        const MethodCall('event', -1),
      ),
      (ByteData? _) {},
    );
    await service.cancelListen();

    expect(interceptionStates, [true, false]);
    expect(events, [VolumeEventType.volumeUp, VolumeEventType.volumeDown]);
    service.onClose();
  });
}
