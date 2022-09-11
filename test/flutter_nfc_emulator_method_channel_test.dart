import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nfc_emulator/flutter_nfc_emulator_method_channel.dart';

void main() {
  MethodChannelFlutterNfcEmulator platform = MethodChannelFlutterNfcEmulator();
  const MethodChannel channel = MethodChannel('flutter_nfc_emulator');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await platform.getPlatformVersion(), '42');
  });
}
