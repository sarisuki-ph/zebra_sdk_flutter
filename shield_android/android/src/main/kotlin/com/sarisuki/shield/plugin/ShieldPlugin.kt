package com.sarisuki.shield.plugin

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.shield.android.Shield
import com.shield.android.ShieldCallback
import com.shield.android.ShieldException

const val LOG_TAG = "shield_android"

class ShieldPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var context: Context? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "shield_android")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when(call.method){
            "getPlatformName" -> {
                result.success("Android")
            }
            "getSessionId"->{
                result.success(getSessionId() ?: "")
            }
            "init" -> {
                val siteId: String = call.argument<String>("siteId") ?: return
                val key: String = call.argument<String>("key") ?: return
                init(siteId, key)
                result.success(null)
            }
            "sendAttributes" -> {
                val screenName: String = call.argument<String>("screenName") ?: return
                val data: HashMap<String, String> = call.argument<HashMap<String, String>>("data") ?: return
                sendAttributes(screenName, data, result)
            }
            "isInitialized" -> {
               result.success(isInitialized())
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getInstance():Shield? {
        return Shield.getInstance()
    }


    private fun isInitialized():Boolean{
        return try {
            getInstance() != null
        } catch (exception: IllegalStateException){
            false
        }
    }

    private fun sendAttributes(screenName: String,
                               data: HashMap<String, String>,
                                @NonNull result: Result) {

        if(!isInitialized()){
            Log.i(LOG_TAG, "cannot send attributes, sdk not initialized.")
            result.success(false)
            return
        }

        Shield.getInstance().setDeviceResultStateListener {
            Shield.getInstance().sendAttributes(screenName, data, object: ShieldCallback<Boolean>{
             override fun onSuccess(p0: Boolean?) {
                Log.i(LOG_TAG, "attributes sent: ${screenName}, $data")
                result.success(p0 ?: false)
            }

            override fun onFailure(p0: ShieldException?) {
                Log.e(LOG_TAG, "error sending attributes: ${screenName}, $data")

                result.error("ShieldFailure",
                    p0?.localizedMessage ?: "failed to send attributes",
                    null
                )
            }
            })
        }
    }

    private fun init(siteId:String, key:String) {
        Log.i(LOG_TAG, "initializing shield")
        if(isInitialized()){
            Log.i(LOG_TAG, "shield is already initialized")
            return
        }

        val shield = Shield.Builder(context!!, siteId, key).build()
        Log.i(LOG_TAG, "shield initialized")
        Shield.setSingletonInstance(shield)
    }

    private fun getSessionId():String? {
        return Shield.getInstance().sessionId
    }
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }
}