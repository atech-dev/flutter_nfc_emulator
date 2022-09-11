import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nfc_emulator/flutter_nfc_emulator.dart';
import 'package:flutter_nfc_emulator/flutter_nfc_emulator_platform_interface.dart';
import 'package:flutter_nfc_emulator/flutter_nfc_emulator_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNfcEmulatorPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNfcEmulatorPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<int?> getNfcStatus() {
    // TODO: implement getNfcStatus
    throw UnimplementedError();
  }

  @override
  Future<void> handleOnReadEmulatorFinished(arguments) {
    // TODO: implement handleOnReadEmulatorFinished
    throw UnimplementedError();
  }

  @override
  Future<void> openNfcSettings() {
    // TODO: implement openNfcSettings
    throw UnimplementedError();
  }

  @override
  Future<void> startNfcEmulator(
      {required String text, NfcReadEmulatorCallback? onReadEmulatorFinished}) {
    // TODO: implement startNfcEmulator
    throw UnimplementedError();
  }

  @override
  Future<void> stopNfcEmulator() {
    // TODO: implement stopNfcEmulator
    throw UnimplementedError();
  }
}

void main() {
  final FlutterNfcEmulatorPlatform initialPlatform =
      FlutterNfcEmulatorPlatform.instance;

  test('$MethodChannelFlutterNfcEmulator is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNfcEmulator>());
  });

  test('getPlatformVersion', () async {
    FlutterNfcEmulator flutterNfcEmulatorPlugin = FlutterNfcEmulator();
    MockFlutterNfcEmulatorPlatform fakePlatform =
        MockFlutterNfcEmulatorPlatform();
    FlutterNfcEmulatorPlatform.instance = fakePlatform;

    // expect(await flutterNfcEmulatorPlugin.getPlatformVersion(), '42');
  });
}
