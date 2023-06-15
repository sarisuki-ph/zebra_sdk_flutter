import android.content.Context
import androidx.annotation.NonNull
import com.symbol.emdk.EMDKManager
import com.symbol.emdk.EMDKManager.EMDKListener
import com.symbol.emdk.EMDKResults
import com.symbol.emdk.barcode.BarcodeManager
import com.symbol.emdk.barcode.ScanDataCollection
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.symbol.emdk.barcode.Scanner
import com.symbol.emdk.barcode.StatusData
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject

class ZebraSdkPlugin : FlutterPlugin, MethodCallHandler, Scanner.StatusListener, Scanner.DataListener, EMDKListener, EventChannel.StreamHandler{
    private lateinit var channel: MethodChannel
    private lateinit var context: Context


    private var emkdManager: EMDKManager? = null;
    private var scanner: Scanner? = null;
    private var barcodeManager: BarcodeManager? = null;

    private var scannerStatusEventSink: EventChannel.EventSink? = null
    private var scannerDataEventSink: EventChannel.EventSink? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "zebra_emsdk_android")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext


        // Create a event channel that will be used to send scanner events back to the
        // application
        val scannerStatusEventChannel = EventChannel(flutterPluginBinding.binaryMessenger,
            "zebra_emsdk_android_scanner_status"
        )
        scannerStatusEventChannel.setStreamHandler(this)

        var scannerDataEventChannel = EventChannel(flutterPluginBinding.binaryMessenger,
            "zebra_emsdk_android_scanner_data"
        )
        scannerDataEventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when(call.method) {
            "getPlatformName" -> {}
            "init" -> {
                val results = EMDKManager.getEMDKManager(context, this)

                // Only return false if the device does not support EMDK
                when (results.statusCode) {
                    EMDKResults.STATUS_CODE.FEATURE_NOT_SUPPORTED -> {
                        // The device does not support EMDK
                        channel.invokeMethod("init", false)
                    }
                    EMDKResults.STATUS_CODE.FAILURE -> {
                        // EMDKManager object initialization failed
                        channel.invokeMethod("init", false)
                    }
                    else -> {

                    }
                }
             }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onStatus(statusData: StatusData?) {
        // Send the scanner status to the application
        scannerDataEventSink?.success(statusData?.state?.name)
    }

    override fun onData(scanDataCollection: ScanDataCollection) {

        // Get the first element from the scan data collection
        val firstScanned = scanDataCollection.scanData?.get(0)

        val dataJson = JSONObject()
        dataJson.put("data", firstScanned?.data)
        dataJson.put("labelType", firstScanned?.labelType)
        dataJson.put("timestamp", firstScanned?.timeStamp)

        // Send the scanner data to the application
        scannerDataEventSink?.success(dataJson.toString())
    }

    override fun onOpened(emdkManager: EMDKManager?) {
        emkdManager = emdkManager
        // Initialize the barcode manager
        barcodeManager = emkdManager?.getInstance(EMDKManager.FEATURE_TYPE.BARCODE) as BarcodeManager

        // Initialize scanner
        scanner = barcodeManager?.getDevice(BarcodeManager.DeviceIdentifier.DEFAULT) as Scanner

        // Add listeners to the scanner
        scanner?.addStatusListener(this)
        scanner?.addDataListener(this)
        channel.invokeMethod("init", true)
    }

    override fun onClosed() {
        if (emkdManager != null) {
            emkdManager?.release()
            emkdManager = null
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        // Check if the provided arguments are for the scanner status or scanner data
        if (arguments == "scanner_status") {
            // Set the scanner status event sink
            scannerStatusEventSink = events
        } else if (arguments == "scanner_data") {
            // Set the scanner data event sink
            scannerDataEventSink = events
        }
    }

    override fun onCancel(arguments: Any?) {
        // Check if the provided arguments are for the scanner status or scanner data
        if (arguments == "scanner_status") {
            // Set the scanner status event sink to null
            scannerStatusEventSink = null
        } else if (arguments == "scanner_data") {
            // Set the scanner data event sink to null
            scannerDataEventSink = null
        }
    }
}