//
//  AutoStartManager.swift
//  ClashX
//
//  Created by 称一称 on 2018/6/14.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Foundation
import ServiceManagement

public struct LaunchAtLogin {
    private static let id = "com.west2online.ClashX.LaunchHelper"
    
    public static var isEnabled: Bool {
        get {
            guard let jobs = (SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String: AnyObject]]) else {
                return false
            }
            let job = jobs.first { $0["Label"] as! String == id }
            return job?["OnDemand"] as? Bool ?? false
        }
        set {
            SMLoginItemSetEnabled(id as CFString, newValue)
        }
    }
}
