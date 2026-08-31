
import {
  FlutterAbility,
  FlutterEngine,
  MethodCall,
  MethodChannel,
  MethodResult
} from '@ohos/flutter_ohos';
import { inputConsumer, KeyCode, KeyEvent } from '@kit.InputKit';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';

const VOLUME_CHANNEL = 'top.jtmonster.jhentai.volume.event.intercept';
const VOLUME_UP = 1;
const VOLUME_DOWN = -1;

export default class EntryAbility extends FlutterAbility {
  private volumeMethodChannel: MethodChannel | null = null;
  private isInterceptingVolumeKeys: boolean = false;

  private readonly volumeUpCallback = (_event: KeyEvent): void => {
    this.volumeMethodChannel?.invokeMethod('event', VOLUME_UP);
  };

  private readonly volumeDownCallback = (_event: KeyEvent): void => {
    this.volumeMethodChannel?.invokeMethod('event', VOLUME_DOWN);
  };

  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    this.volumeMethodChannel = new MethodChannel(
      flutterEngine.getDartExecutor(),
      VOLUME_CHANNEL
    );
    this.volumeMethodChannel.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        if (call.method !== 'set') {
          result.notImplemented();
          return;
        }

        try {
          const enabled = call.args as boolean;
          if (enabled) {
            this.startInterceptingVolumeKeys();
          } else {
            this.stopInterceptingVolumeKeys();
          }
          result.success(null);
        } catch (error) {
          result.error(
            'VOLUME_INTERCEPT_ERROR',
            `Failed to update volume key interception: ${JSON.stringify(error)}`,
            null
          );
        }
      }
    });
  }

  private startInterceptingVolumeKeys(): void {
    if (this.isInterceptingVolumeKeys) {
      return;
    }

    inputConsumer.on('keyPressed', {
      key: KeyCode.KEYCODE_VOLUME_UP,
      action: 1,
      isRepeat: true
    }, this.volumeUpCallback);

    try {
      inputConsumer.on('keyPressed', {
        key: KeyCode.KEYCODE_VOLUME_DOWN,
        action: 1,
        isRepeat: true
      }, this.volumeDownCallback);
      this.isInterceptingVolumeKeys = true;
    } catch (error) {
      inputConsumer.off('keyPressed', this.volumeUpCallback);
      throw new Error(
        `Failed to subscribe to volume-down events: ${JSON.stringify(error)}`
      );
    }
  }

  private stopInterceptingVolumeKeys(): void {
    if (!this.isInterceptingVolumeKeys) {
      return;
    }

    inputConsumer.off('keyPressed', this.volumeUpCallback);
    inputConsumer.off('keyPressed', this.volumeDownCallback);
    this.isInterceptingVolumeKeys = false;
  }

  onDestroy() {
    try {
      this.stopInterceptingVolumeKeys();
    } catch (error) {
      console.error(`Failed to stop volume key interception: ${JSON.stringify(error)}`);
    }
    this.volumeMethodChannel?.setMethodCallHandler(null);
    this.volumeMethodChannel = null;
    super.onDestroy();
  }
}
