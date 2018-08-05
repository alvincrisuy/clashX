//
//  ProxyServerModel.swift
//  ClashX
//
//  Created by CYC on 2018/8/5.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Cocoa

class ProxyServerModel: NSObject, Codable {
    @objc dynamic var serverHost:String = ""
    @objc dynamic var serverPort:String = ""
    @objc dynamic var password:String = ""
    @objc dynamic var method:String = "RC4-MD5"
    @objc dynamic var remark:String = "Proxy"
    
    func isValid() -> Bool {
        func validateIpAddress(_ ipToValidate: String) -> Bool {
            
            var sin = sockaddr_in()
            var sin6 = sockaddr_in6()
            
            if ipToValidate.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
                // IPv6 peer.
                return true
            }
            else if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
                // IPv4 peer.
                return true
            }
            
            return false;
        }
        
        func validateDomainName(_ value: String) -> Bool {
            let validHostnameRegex = "^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$"
            
            if (value.range(of: validHostnameRegex, options: .regularExpression) != nil) {
                return true
            } else {
                return false
            }
        }
        
        func validatePort(_ value: String) -> Bool {
            if let port = Int(value) {
                return port > 0 && port <= 65535
            }
            return false
        }
        
        if !(validateIpAddress(serverHost) ||
            validateDomainName(serverHost) ||
            validatePort(serverPort)){
            return false
        }
        
        if password.isEmpty {
            return false
        }
        
        return true
    }
    

}
