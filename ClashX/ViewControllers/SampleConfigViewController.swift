//
//  SampleConfigViewController.swift
//  ClashX
//
//  Created by 称一称 on 2018/6/13.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Cocoa

class SampleConfigViewController: NSViewController {

    @IBOutlet weak var serverAddressTextField: NSTextField!
    @IBOutlet weak var serverPortTextField: NSTextField!
    @IBOutlet weak var serverPasswordTextField: NSSecureTextField!
    @IBOutlet weak var serverencryptMethodBox: NSComboBox!
    override func viewDidLoad() {
        super.viewDidLoad()
        serverencryptMethodBox.addItems(withObjectValues: [
            "AES-128-CTR",
            "AES-192-CTR",
            "AES-256-CTR",
            "AES-128-CFB",
            "AES-192-CFB",
            "AES-256-CFB",
            "CHACHA20-IETF",
            "XCHACHA20",
            "AEAD_AES_128_GCM",
            "AEAD_AES_192_GCM",
            "AEAD_AES_256_GCM",
            "AEAD_CHACHA20_POLY1305"
            ])

    }
    
    func vaildConfig()->Bool {
        if let port = Int(serverPortTextField.stringValue) {
            if port > 0 && port <= 65535 {
                return serverPortTextField.stringValue.count > 0 &&
                serverPasswordTextField.stringValue.count > 0
            }
        }
        return false
    }
    
    func generateConfig() {
        let originalConfig = NSData(contentsOfFile: Bundle.main.path(forResource: "sampleConfig", ofType: "ini")!)
        
        var configStr = String(data: originalConfig! as Data, encoding: .utf8)
        
        let targetStr = "Proxy = ss, \(serverAddressTextField.stringValue), \(serverPortTextField.stringValue), \(serverencryptMethodBox.stringValue), \(serverPasswordTextField.stringValue)"
        
        configStr = configStr?.replacingOccurrences(of: "{{placeHolder}}", with: targetStr)
        
        // save to ~/.config/clash/config.ini
        let path = (NSHomeDirectory() as NSString).appendingPathComponent("/.config/clash/config.ini")

        if (FileManager.default.fileExists(atPath: path)) {
            try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))
        }
        try? configStr?.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
                
    }
    
    
    @IBAction func actionConfirm(_ sender: Any) {
        if (vaildConfig()) {
            generateConfig()
        }
        self.view.window?.windowController?.close()
        
    }
    
}
