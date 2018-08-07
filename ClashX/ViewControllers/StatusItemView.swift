//
//  StatusItemView.swift
//  ClashX
//
//  Created by 称一称 on 2018/6/23.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Foundation
import AppKit
import RxCocoa
import RxSwift

class StatusItemView: NSView {
    
    @IBOutlet var imageView: NSImageView!
    
    @IBOutlet var uploadSpeedLabel: NSTextField!
    @IBOutlet var downloadSpeedLabel: NSTextField!
    @IBOutlet weak var speedContainerView: NSView!
    weak var statusItem:NSStatusItem?
    var disposeBag = DisposeBag()
    
    var onPopUpMenuAction:(()->())? = nil
    
    static func create(statusItem:NSStatusItem?,statusMenu:NSMenu)->StatusItemView{
        var topLevelObjects : NSArray?
        if Bundle.main.loadNibNamed(NSNib.Name(rawValue: "StatusItemView"), owner: self, topLevelObjects: &topLevelObjects) {
            let view = (topLevelObjects!.first(where: { $0 is NSView }) as? StatusItemView)!
            view.statusItem = statusItem
            view.menu = statusMenu
            view.setupView()
            statusMenu.delegate = view
            return view
        }
        return NSView() as! StatusItemView
    }
    
    func setupView() {
        UserDefaults.standard
            .rx.observe(String.self, "AppleInterfaceStyle").bind {
            value in
            let darkMode = (value ?? "Light") == "Dark"
            let image = NSImage(named: NSImage.Name(rawValue: "menu_icon"))!.tint(color: darkMode ? NSColor.white : NSColor.black)
            self.imageView.image = image
        }.disposed(by: disposeBag)
    }
    
    func updateSpeedLabel(up:Int,down:Int) {
        let kbup = up/1024
        let kbdown = down/1024
        var finalUpStr:String
        var finalDownStr:String
        if kbup < 1024 {
            finalUpStr = "\(kbup)KB/s"
        } else {
            finalUpStr = String(format: "%.2fMB/s", (Double(kbup)/1024.0))
        }
        
        if kbdown < 1024 {
            finalDownStr = "\(kbdown)KB/s"
        } else {
            finalDownStr = String(format: "%.2fMB/s", (Double(kbdown)/1024.0))
        }
        DispatchQueue.main.async {
            self.downloadSpeedLabel.stringValue = finalDownStr
            self.uploadSpeedLabel.stringValue = finalUpStr
        }
   
    }
    
    func showSpeedContainer(show:Bool) {
        self.speedContainerView.isHidden = !show
    }
    
    override func mouseDown(with event: NSEvent) {
        onPopUpMenuAction?()
        statusItem?.popUpMenu(self.menu!)
    }
}

extension StatusItemView:NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        drawHighlight(highlight: true)

    }
    
    func menuDidClose(_ menu: NSMenu) {
        drawHighlight(highlight: false)
    }
    
    
    func drawHighlight(highlight:Bool) {
        let image = NSImage(size: self.frame.size)
        image.lockFocus()
        statusItem?.drawStatusBarBackground(in: self.bounds, withHighlight: highlight)
        image.unlockFocus()
        self.layer?.contents = image
    }
}
