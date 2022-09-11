import 'package:flutter_nfc_emulator/types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_nfc_emulator_method_channel.dart';

abstract class FlutterNfcEmulatorPlatform extends PlatformInterface {
  /// Constructs a FlutterNfcEmulatorPlatform.
  FlutterNfcEmulatorPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNfcEmulatorPlatform _instance =
      MethodChannelFlutterNfcEmulator();

  /// The default instance of [FlutterNfcEmulatorPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNfcEmulator].
  static FlutterNfcEmulatorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNfcEmulatorPlatform] when
  /// they register themselves.
  static set instance(FlutterNfcEmulatorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startNfcEmulator({
    required String text,
    NfcReadEmulatorCallback? onReadEmulatorFinished,
  }) {
    throw UnimplementedError('startNfcEmulator() has not been implemented.');
  }

  Future<void> stopNfcEmulator() {
    throw UnimplementedError('stopNfcEmulator() has not been implemented.');
  }

  Future<int?> getNfcStatus() {
    throw UnimplementedError('getNfcStatus() has not been implemented.');
  }

  Future<void> openNfcSettings() {
    throw UnimplementedError('openNfcSettings() has not been implemented.');
  }

  Future<void> handleOnReadEmulatorFinished(dynamic arguments) {
    throw UnimplementedError(
        'handleOnReadEmulatorFinished() has not been implemented.');
  }
}
