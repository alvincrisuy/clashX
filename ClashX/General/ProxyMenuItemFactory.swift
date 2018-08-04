//
//  ProxyMenuItemFactory.swift
//  ClashX
//
//  Created by CYC on 2018/8/4.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Cocoa
import SwiftyJSON
import RxCocoa

class ProxyMenuItemFactory {
    static func menuItems(completionHandler:@escaping (([NSMenuItem])->())){
        ApiRequest.requestProxyGroupList { (res) in
            let dataDict = JSON(res)
            var menuItems = [NSMenuItem]()
            for proxyGroup in dataDict.dictionaryValue {
                guard proxyGroup.value["type"].stringValue == "Selector" else {continue}
                let menu = NSMenuItem(title: proxyGroup.key, action: nil, keyEquivalent: "")
                let selectedName = proxyGroup.value["now"].stringValue
                let submenu = NSMenu(title: proxyGroup.key)
                for proxy in proxyGroup.value["all"].arrayValue.reversed() {
                    let proxyItem = NSMenuItem(title: proxy.stringValue, action: #selector(ProxyMenuItemFactory.actionSelectProxy(sender:)), keyEquivalent: "")
                    proxyItem.target = ProxyMenuItemFactory.self
                    proxyItem.state = proxy.stringValue == selectedName ? .on : .off
                    submenu.addItem(proxyItem)
                }
                menu.submenu = submenu
                menuItems.append(menu);
            }
            completionHandler(menuItems.reversed())
        }
    }
    
    @objc static func actionSelectProxy(sender:NSMenuItem){
        guard let proxyGroup = sender.menu?.title else {return}
        let proxyName = sender.title
        
        ApiRequest.updateProxyGroup(group: proxyGroup, selectProxy: proxyName) { (success) in
            if (success) {
                for items in sender.menu?.items ?? [NSMenuItem]() {
                    items.state = .off
                }
                sender.state = .on
            }
        }
        

    }
    
    
}
