import 'flutter_nfc_emulator_platform_interface.dart';

enum NfcStatus { unknown, enabled, notSupported, notEnabled }

// Signature for `FlutterNfcEmulator.startNfcEmulator` onReadEmulatorFinished callback.
typedef NfcReadEmulatorCallback = void Function(dynamic response);

class FlutterNfcEmulator {
  /*
   * Get NFC status
   */
  static Future<NfcStatus> get nfcStatus async {
    final int? status =
        await FlutterNfcEmulatorPlatform.instance.getNfcStatus();
    return _parseNfcStatus(status);
  }

  /*
   * Is NFC available
   */
  static Future<bool> get isAvailable async {
    return NfcStatus.enabled == await nfcStatus;
  }

  /// Start NFC Emulator session and register callbacks for device read.
  ///
  /// This uses the NfcAdapter#enableReaderMode (on Android).
  /// Requires Android API 19, or later.
  ///
  /// `text` Any text greater than 10 Characthers
  ///
  /// `onReadEmulatorFinished` is called whenever the tag is discovered.
  static Future<void> startNfcEmulator({
    required String text,
    NfcReadEmulatorCallback? onReadEmulatorFinished,
  }) async {
    await FlutterNfcEmulatorPlatform.instance.startNfcEmulator(
      text: text,
      onReadEmulatorFinished: onReadEmulatorFinished,
    );
  }

  /*
   * Stop NFC Emulator
   */
  static Future<void> stopNfcEmulator() async {
    await FlutterNfcEmulatorPlatform.instance
        .handleOnReadEmulatorFinished(null);
    await FlutterNfcEmulatorPlatform.instance.stopNfcEmulator();
  }

  /*
   * Open device NFC setting to enable it
   */
  static Future<void> openNfcSettings() async {
    await FlutterNfcEmulatorPlatform.instance.openNfcSettings();
  }

  static NfcStatus _parseNfcStatus(int? value) {
    switch (value) {
      case -1:
        return NfcStatus.unknown;
      case 0:
        return NfcStatus.enabled;
      case 1:
        return NfcStatus.notSupported;
      case 2:
        return NfcStatus.notEnabled;
      default:
        return NfcStatus.unknown;
    }
  }
}
