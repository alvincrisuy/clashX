//
//  ConfigManager.swift
//  ClashX
//
//  Created by 称一称 on 2018/6/12.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift

class ConfigManager {
    
    static let shared = ConfigManager()
    
    var currentConfig:ClashConfig?{
        get {
            return currentConfigVariable.value
        }
        
        set {
            currentConfigVariable.value = newValue
        }
    }
    var currentConfigVariable = Variable<ClashConfig?>(nil)
    
    var proxyPortAutoSet:Bool {
        get{
            return UserDefaults.standard.bool(forKey: "proxyPortAutoSet")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "proxyPortAutoSet")
        }
    }
    let proxyPortAutoSetObservable = UserDefaults.standard.rx.observe(Bool.self, "proxyPortAutoSet")
    
    static var apiUrl:String{
        get {
            return "http://127.0.0.1:8080"
        }
    }
    
}
