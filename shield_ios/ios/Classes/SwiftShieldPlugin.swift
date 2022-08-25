
import Flutter
import ShieldFraud
import CoreFoundation


public class SwiftShieldPlugin : NSObject, FlutterPlugin {

    var isInitialized: Bool = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name:"shield_ios", binaryMessenger: registrar.messenger())
        
        
        let instance = SwiftShieldPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel )
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformName":
            result("iOS")
            break
        case "init":
            initShield(call: call, result: result)
            break
        case "sendAttributes":
            sendAttributes(call: call, result: result)
            break
        case "getSessionId":
            getSessionId(result: result)
            break
        case "isInitialized":
            result(isInitialized)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    
    private func sendAttributes(call: FlutterMethodCall, result: @escaping FlutterResult){
        guard let args = call.arguments as? [String: Any],
        let screenName = args["screenName"] as? String,
        let data = args["data"] as? Dictionary<String,String> else {
            return
        }
        
        Shield.shared().setDeviceResultStateListener({
            Shield.shared().sendAttributes(withScreenName: screenName, data:data){
                (status, error) in
                if let error = error {
                    debugPrint("shield_ios: ShieldFailure:\(error.localizedDescription)")
                    result(false)
                } else {
                    result(status)
                }
            }
            
        })
    }
    
    private func getSessionId(result: @escaping FlutterResult) {
        let sessionId = Shield.shared().sessionId
        result(sessionId)
    }
    
    private func initShield(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: String],
              let siteId = args["siteId"],
        let key = args["key"] else {
            return
        }
        
        debugPrint("shield_ios: initializing shield")
        if(isInitialized){
            debugPrint("shield_ios: shield is already initialized")
            result(nil);
            return
        }
        isInitialized = true
        debugPrint("shield_ios: shield initialized")
        let config = Configuration(withSiteId: siteId, secretKey: key)
        Shield.setUp(with: config)
        result(nil)

    }
    
}
