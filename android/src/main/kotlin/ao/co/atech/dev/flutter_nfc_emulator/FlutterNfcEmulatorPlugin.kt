package ao.co.atech.dev.flutter_nfc_emulator

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.nfc.NfcAdapter
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.ResultReceiver
import android.text.TextUtils
import androidx.annotation.NonNull
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterNfcEmulatorPlugin */
class FlutterNfcEmulatorPlugin: FlutterPlugin, ActivityAware, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private val TAG = "FlutterNfcEmulatorPlugin"
  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity
  private var adapter: NfcAdapter? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_nfc_emulator")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "startNfcEmulator" -> handleStartNfcEmulator(call, result)
      "stopNfcEmulator" -> handleStopNfcEmulator(call, result)
      "getNfcStatus" -> handleGetNfcStatus(call, result)
      "openNfcSettings" -> handleOpenNfcSettings(call, result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(@NonNull activityPluginBinding: ActivityPluginBinding) {
    activity = activityPluginBinding.getActivity();
  }

  override fun onReattachedToActivityForConfigChanges(@NonNull activityPluginBinding: ActivityPluginBinding) {
    activity = activityPluginBinding.getActivity();
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // no op
  }

  override fun onDetachedFromActivity() {
    // no op
  }

  private fun handleStartNfcEmulator(call: MethodCall, result: Result) {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
      result.error("unavailable", "Requires API level 19.", null)
    } else {
      val adapter = adapter ?: run {
        result.error("unavailable", "NFC is not available for device.", null)
        return
      }

      if (checkNFCEnable() && activity.packageManager.hasSystemFeature(PackageManager.FEATURE_NFC_HOST_CARD_EMULATION)) {
        val text = call.argument<String>("text")
        if (text == null || TextUtils.isEmpty(text)) {
          result.error("no_text", "NFC emulator text cannot be null or empty.", null)
        } else {
          startNfcEmulator(text);
          result.success(null)
        }
      } else {
        result.error("unavailable", "NFC is not available for device.", null)
      }
    }
  }

  private fun handleStopNfcEmulator(call: MethodCall, result: Result) {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
      result.error("unavailable", "Requires API level 19.", null)
    } else {
      val adapter = adapter ?: run {
        result.error("unavailable", "NFC is not available for device.", null)
        return
      }
      val intent = Intent(activity, FlutterNfcEmulatorService::class.java)
      activity.stopService(intent)

      adapter.disableReaderMode(activity)
      result.success(null)
    }
  }

  private fun handleGetNfcStatus(call: MethodCall, result: Result) {
    val status: Int = getNfcStatus()
    result.success(status)
  }

  private fun handleOpenNfcSettings(call: MethodCall, result: Result) {
    activity.startActivity(Intent(android.provider.Settings.ACTION_NFC_SETTINGS))
    result.success(null)
  }

  private fun startNfcEmulator(text: String) {
    val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
      Intent(activity, FlutterNfcEmulatorService::class.java)
    } else {
      null
    }

    if(intent != null) {
      intent.putExtra("ndefMessage", text)
      intent.putExtra(
        "listener",
        object : ResultReceiver(Handler()) {
          @SuppressLint("LongLogTag")
          override fun onReceiveResult(resultCode: Int, resultData: Bundle) {
            super.onReceiveResult(resultCode, resultData)
            if (resultCode == Activity.RESULT_OK) {
              val value = resultData.getString("value")
              channel.invokeMethod("onReadEmulatorFinished", value)
            } else {
              Log.i(TAG, "+++++++++++++RESULT_NOT_OK++++++++++++")
            }
          }
        })
      activity.startService(intent)
    } else {
      Log.e(TAG, "Unable to startNfcEmulator because App version error")
    }
  }

  private fun getNfcStatus(): Int {
    adapter = NfcAdapter.getDefaultAdapter(activity);
    if (adapter == null) {
        // This device does not support NFC
        return 1;
    }
    if (adapter != null && (adapter?.isEnabled == false)) {
        // NFC not enabled
        return 2;
    }
    return 0;
  }

  private fun checkNFCEnable(): Boolean {
    return if (adapter == null) {
      false
    } else {
      adapter!!.isEnabled
    }
  }
}
