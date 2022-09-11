import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_emulator/types.dart';

import 'flutter_nfc_emulator_platform_interface.dart';

/// An implementation of [FlutterNfcEmulatorPlatform] that uses method channels.
class MethodChannelFlutterNfcEmulator extends FlutterNfcEmulatorPlatform {
  late NfcReadEmulatorCallback? onReadEmulatorFinishedCall;

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_nfc_emulator');

  @override
  Future<void> startNfcEmulator({
    required String text,
    NfcReadEmulatorCallback? onReadEmulatorFinished,
  }) async {
    onReadEmulatorFinishedCall = onReadEmulatorFinished;
    methodChannel.setMethodCallHandler(_handleMethodCall);
    await methodChannel.invokeMethod<dynamic>('startNfcEmulator', {
      "text": text,
    });
  }

  @override
  Future<void> stopNfcEmulator() async {
    await methodChannel.invokeMethod<dynamic>('stopNfcEmulator');
  }

  @override
  Future<int?> getNfcStatus() async {
    final status = await methodChannel.invokeMethod<int>('getNfcStatus');
    return status;
  }

  @override
  Future<void> openNfcSettings() async {
    await methodChannel.invokeMethod<dynamic>('openNfcSettings');
  }

  // _handleOnReadEmulatorFinished
  @override
  Future<void> handleOnReadEmulatorFinished(dynamic arguments) async {
    onReadEmulatorFinishedCall?.call(arguments);
  }

  // _handleOnDiscovered
  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onReadEmulatorFinished':
        handleOnReadEmulatorFinished(call.arguments);
        break;
      /*case 'onError':
        _handleOnError(call);
        break;*/
      default:
        throw ('Not implemented: ${call.method}');
    }
  }
}
