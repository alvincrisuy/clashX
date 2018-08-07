//
//  Logger.swift
//  ClashX
//
//  Created by CYC on 2018/8/7.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Foundation
import os

class Logger {
    static let shared = Logger()
    var logger:OSLog?
    private init() {
        if #available(OSX 10.12, *) {
            self.logger = OSLog(subsystem: "com.clashX", category: "clashX")
        } else {
        }
    }
    
    static func log(msg:String) {
        if #available(OSX 10.12, *) {
            os_log("%{public}s", log: shared.logger!, type: .default, msg)
        } else {
            NSLog("%@", msg)
        }
    }
}
