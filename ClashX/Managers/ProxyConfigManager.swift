
import Foundation
class ProxyConfigManager {
    static let kProxyConfigPath = (NSHomeDirectory() as NSString).appendingPathComponent("/.config/clash/")
    static let kProxyHelperPath = "/Library/Application Support/clashX/ProxyConfig"
//    static let kProxyConfigPath = Bundle.main.path(forResource: "ProxyConfig", ofType: nil)
    static let kVersion = "0.4.0"

    
    open static func checkVersion() -> Bool {
        let scriptPath = "\(Bundle.main.resourcePath!)/check_proxy_helper.sh"
        print(scriptPath)
        let appleScriptStr = "do shell script \"bash \(scriptPath)\""
        let appleScript = NSAppleScript(source: appleScriptStr)
        var dict: NSDictionary?
        if let res = appleScript?.executeAndReturnError(&dict) {
            print(res.stringValue ?? "")
            if (res.stringValue?.contains("root")) ?? false {
                return true
            }
        }
        return false
        
    }

    open static func install() -> Bool {
        checkMMDB()
        if  !checkVersion() {
            let scriptPath = "\(Bundle.main.resourcePath!)/install_proxy_helper.sh"
            let appleScriptStr = "do shell script \"bash \(scriptPath)\" with administrator privileges"
            let appleScript = NSAppleScript(source: appleScriptStr)
            var dict: NSDictionary?
            if let res = appleScript?.executeAndReturnError(&dict) {
                print(res)
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    static func checkMMDB() {
        let fileManage = FileManager.default
        let destMMDBPath = (NSHomeDirectory() as NSString).appendingPathComponent("/.config/clash/Country.mmdb")
        if !fileManage.fileExists(atPath: destMMDBPath) {
            let mmdbPath = Bundle.main.path(forResource: "Country", ofType: "mmdb")
            try! fileManage.copyItem(at: URL(fileURLWithPath: mmdbPath!), to: URL(fileURLWithPath: destMMDBPath))
        }
    }
    
    open static func setUpSystemProxy(port: Int?,socksPort: Int?) -> Bool {
        let task = Process()
        task.launchPath = kProxyHelperPath
        if let port = port,let socksPort = socksPort {
            task.arguments = [String(port),String(socksPort), "enable"]
        } else {
            task.arguments = ["0", "0", "disable"]
        }
        
        task.launch()
        
        task.waitUntilExit()
        
        if task.terminationStatus != 0 {
            return false
        }
        return true
    }
}
