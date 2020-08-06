package id.pptik.surveypptik

import android.telephony.TelephonyManager
import android.annotation.SuppressLint
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.telephony.CellSignalStrength

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "jurnalamari.pptik.id/battery"
    
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
          MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      // Note: this method is invoked on the main thread.
      call, result ->
      if (call.method == "getBatteryLevel") {
        val batteryLevel = getSignalStrength()

        if (batteryLevel != null) {
          result.success(batteryLevel)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }
      } else {
        result.notImplemented()
      }
    }

    }

  @SuppressLint("NewApi")
    private fun getSignalStrength(): Int{
        val sd : Int
        val signalManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        if (VERSION.SDK_INT >= VERSION_CODES.P) {
            sd = signalManager.signalStrength!!.gsmSignalStrength
            return sd
        }else{
            sd = signalManager.signalStrength!!.gsmSignalStrength

            return sd
        }

        return 0
    }
      private fun getBatteryLevel(): Int {
    val batteryLevel: Int
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
    }

    return batteryLevel
  }
    // override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)
    //     val permission = ContextCompat.checkSelfPermission(this,
    //             Manifest.permission.READ_PHONE_STATE)

    //     if (permission != PackageManager.PERMISSION_GRANTED) {
    //         ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_PHONE_STATE), 1)
    //     }else{

    //     }
    //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
    //         // Note: this method is invoked on the main thread.
    //         call, result ->
    //         if (call.method == "getBatteryLevel") {
    //             val batteryLevel = getBatteryLevel()

    //             if (batteryLevel != null) {
    //                 result.success(batteryLevel)
    //             } else {
    //                 result.error("UNAVAILABLE", "Battery level not available.", null)
    //             }
    //         } else {
    //             result.notImplemented()
    //         }
    //     }
    // }

    // private fun getBatteryLevel(): Int {
    //     val batteryLevel: Int
    //     if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
    //         val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    //         batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    //     } else {
    //         val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    //         batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTR  A_SCALE, -1)
    //     }

    //     return batteryLevel
    // }
}