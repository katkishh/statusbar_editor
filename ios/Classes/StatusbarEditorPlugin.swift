import Flutter
import UIKit

public class StatusbarEditorPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "statusbar_editor", binaryMessenger: registrar.messenger())
        let instance = StatusbarEditorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "changeStatusBarColor":
            let color = convertARGGDictToColor(colorComponents: call.arguments as? Dictionary<String, Double> ?? [:])
            if color == nil {
                result(nil)
                return
            }
            changeStatusBarColor(color!)
            result(nil)
        case "changeStatusBarTheme":
            let args:Dictionary<String, Any> = call.arguments as? Dictionary<String, Any> ?? [:]
            let isLight: Bool = args["is_light"] as! Bool
            changeTheme(isLight: isLight, color: convertARGGDictToColor(colorComponents: args))
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func changeStatusBarColor(_ color:UIColor){
        let statusBarView = getView()
        statusBarView.backgroundColor = color
        let window = getWindow()
        window?.rootViewController?.view.addSubview(statusBarView)
    }
    
    private func changeTheme(isLight: Bool, color: UIColor?){
        UIApplication.shared.connectedScenes.flatMap{($0 as? UIWindowScene)?.windows ?? []}.forEach{window in
            window.overrideUserInterfaceStyle = if isLight{.light} else {.dark}
        }
        let statusBarView = getView()
        statusBarView.overrideUserInterfaceStyle = .light
        guard color == nil else {
            changeStatusBarColor(color!)
            return
        }
    }
    
    private func getWindow() -> UIWindow?{
        let window: UIWindow? = if #available(iOS 15.0, *){
            UIApplication.shared.connectedScenes.compactMap{($0 as? UIWindowScene)?.keyWindow}.last
        } else {
            UIApplication.shared.connectedScenes.flatMap({($0 as? UIWindowScene)?.windows ?? []}).last
        }
        return window
    }
    
    private func getView() -> UIView{
        let window = getWindow()
        let statusBarFrame: CGRect
        if let windowScene = window?.windowScene {
            statusBarFrame = windowScene.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = CGRect.zero
        }
        
        let statusBarView = UIView(frame: statusBarFrame)
        return statusBarView
    }
    
    private func convertARGGDictToColor(colorComponents: Dictionary<String, Any>) -> UIColor?{
        guard colorComponents.keys.count > 3 else {
            return nil
        }
        let a = colorComponents["a"] as! Double
        let r = colorComponents["r"] as! Double
        let g = colorComponents["g"] as! Double
        let b = colorComponents["b"] as! Double
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
