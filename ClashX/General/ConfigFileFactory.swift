//
//  ConfigFileFactory.swift
//  ClashX
//
//  Created by CYC on 2018/8/5.
//  Copyright © 2018年 west2online. All rights reserved.
//
import Foundation

class ConfigFileFactory {
    static func configFile(proxies:[ProxyServerModel]) -> String {
        var proxyStr = ""
        var proxyGroupStr = ""
        for proxy in proxies {
            let targetStr = "\(proxy.remark) = ss, \(proxy.serverHost), \(proxy.serverPort), \(proxy.method), \(proxy.password)\n"
            proxyStr.append(targetStr)
            proxyGroupStr.append("\(proxy.remark),")
        }
        let sampleConfig = NSData(contentsOfFile: Bundle.main.path(forResource: "sampleConfig", ofType: "ini")!)
        var sampleConfigStr = String(data: sampleConfig! as Data, encoding: .utf8)
        

        
        if proxies.count > 1 {
            let autoGroupStr = "ProxyAuto = url-test, \(proxyGroupStr), http://www.google.com/generate_204, 300"
            sampleConfigStr = sampleConfigStr?.replacingOccurrences(of: "{{ProxyAutoGroupPlaceHolder}}", with: autoGroupStr)
            proxyGroupStr.append("ProxyAuto,")
        }
        proxyGroupStr = String(proxyGroupStr.dropLast())

        sampleConfigStr = sampleConfigStr?.replacingOccurrences(of: "{{ProxyPlaceHolder}}", with: proxyStr)
        sampleConfigStr = sampleConfigStr?.replacingOccurrences(of: "{{ProxyGroupPlaceHolder}}", with: proxyGroupStr)

        return sampleConfigStr!
    }
    
    static func saveToClashConfigFile(str:String) {
        // save to ~/.config/clash/config.ini
        let path = (NSHomeDirectory() as NSString).appendingPathComponent("/.config/clash/config.ini")
        
        if (FileManager.default.fileExists(atPath: path)) {
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))
        }
        try? str.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
    }
}
