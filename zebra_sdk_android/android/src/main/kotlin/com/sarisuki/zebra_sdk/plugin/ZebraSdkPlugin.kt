package com.sarisuki.zebra_sdk.plugin

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
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
import com.symbol.emdk.barcode.ScannerException
import com.symbol.emdk.barcode.StatusData
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject

class ZebraSdkPlugin : FlutterPlugin, MethodCallHandler, Scanner.StatusListener, Scanner.DataListener, EMDKListener, EventChannel.StreamHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context


    private var emdkManager: EMDKManager? = null;
    private var scanner: Scanner? = null;
    private var barcodeManager: BarcodeManager? = null;

    private var uiThreadHandler = Handler(Looper.getMainLooper());
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
        deInitScanner()
        deInitBarcodeManager()
        deInitEmdkManager()

    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when(call.method) {
            "getPlatformName" -> {}
            "init" -> {
                val results = EMDKManager.getEMDKManager(context, this)

                // Only return false if the device does not support EMDK
                if(results.statusCode != EMDKResults.STATUS_CODE.SUCCESS) {
                    result.success(false)
                }
                else {
                    result.success(true)
                }
             }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onStatus(statusData: StatusData?) {
        // Send the scanner status to the application
        val state = statusData?.state
        uiThreadHandler.post {
            scannerStatusEventSink?.success(state?.name)
        }
        Log.d("ZebraSdkPlugin", "Scanner state: $state")
        when(state) {
            StatusData.ScannerStates.IDLE -> {
                try {
                    // On Idle, we can proceed in accept a new scan
                    scanner?.read()
                } catch (e: ScannerException) {
                    Log.d("ZebraSdkPlugin", "Scanner read exception: $e")
                }
            }
            null -> {
                scannerStatusEventSink?.success("NULL")
            }
            else -> {}
        }
    }

    override fun onData(scanDataCollection: ScanDataCollection) {

        try {
            // Get the first element from the scan data collection
            val firstScanned = scanDataCollection.scanData?.get(0)

            val dataJson = JSONObject()
            dataJson.put("data", firstScanned?.data)
            dataJson.put("labelType", firstScanned?.labelType)
            dataJson.put("timestamp", firstScanned?.timeStamp)

            // Send the scanner data to the application
            uiThreadHandler.post {
                scannerDataEventSink?.success(dataJson.toString())
            }
        } catch (e: Exception) {
            Log.d("ZebraSdkPlugin", "Scanner data exception: $e")
        }
    }

    private fun deInitEmdkManager(){
        if(emdkManager != null){
            emdkManager?.release()
            emdkManager = null
        }
    }

    private fun initBarcodeManager() {
        Log.d("ZebraSdkPlugin", "Getting barcode manager")
        barcodeManager = emdkManager?.getInstance(EMDKManager.FEATURE_TYPE.BARCODE) as BarcodeManager
        Log.d("ZebraSdkPlugin", "Barcode manager: $barcodeManager")
    }

    private fun deInitBarcodeManager(){
        if(emdkManager != null){
            emdkManager?.release(EMDKManager.FEATURE_TYPE.BARCODE)
        }
    }
    private fun initScanner() {
        Log.d("ZebraSdkPlugin", "Initializing Scanner")

        // Fetch all the available scanner and get the first one
        scanner = barcodeManager?.getDevice(BarcodeManager.DeviceIdentifier.DEFAULT)

        if(scanner != null){
            try {
                scanner?.enable()
                scanner?.triggerType = Scanner.TriggerType.HARD
                scanner?.addStatusListener(this)
                scanner?.addDataListener(this)

                scanner?.read()

                Log.d("ZebraSdkPlugin", "Scanner initialized")

            } catch (e: ScannerException) {
                deInitScanner()
                Log.d("ZebraSdkPlugin", "Scanner exception: $e")
                Log.d("ZebraSdkPlugin", "Reinitializing scanner")
                initScanner()
            }
        } else {
            Log.d("ZebraSdkPlugin", "Scanner is null")
        }
    }
    override fun onOpened(emdkManager: EMDKManager?) {
        this.emdkManager = emdkManager
        Log.d("ZebraSdkPlugin", "EMDK Manager: ${this.emdkManager}")
        // Initialize the barcode manager
        Log.d("ZebraSdkPlugin", "Getting barcode manager")


        initBarcodeManager()

        initScanner()

    }

    /**
     * De-initialize the scanner
     *
     * This makes sure that all the listeners are removed and the scanner is released properly
     */
    private fun deInitScanner(){
        if (scanner != null) {
            try {
                scanner?.disable()
            } catch(e: ScannerException) {
                Log.d("ZebraSdkPlugin", "Scanner disable exception: $e")
            }

            try {
                // Remove listeners from the scanner
                scanner?.removeStatusListener(this)
                scanner?.removeDataListener(this)
            } catch(e: ScannerException) {
                Log.d("ZebraSdkPlugin", "Scanner remove status listener exception: $e")
            }

            try {
                scanner?.release()
            } catch(e: ScannerException) {
                Log.d("ZebraSdkPlugin", "Scanner release exception: $e")
            }

            scanner = null
        }
    }


    override fun onClosed() {
        if (emdkManager != null) {
            emdkManager?.release()
            emdkManager = null
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