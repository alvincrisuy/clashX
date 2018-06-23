//
//  StatusItemView.swift
//  ClashX
//
//  Created by 称一称 on 2018/6/23.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Foundation
import AppKit
class StatusItemView: NSView {
    
    @IBOutlet var imageView: NSImageView!
    @IBOutlet var uploadSpeedLabel: NSLayoutConstraint!
    
    @IBOutlet var downloadSpeedLabel: NSTextField!
    weak var statusItem:NSStatusItem?
    
    static func create(statusItem:NSStatusItem,statusMenu:NSMenu)->StatusItemView{
        var topLevelObjects : NSArray?
        if Bundle.main.loadNibNamed(NSNib.Name(rawValue: "StatusItemView"), owner: self, topLevelObjects: &topLevelObjects) {
            let view = (topLevelObjects!.first(where: { $0 is NSView }) as? StatusItemView)!
            view.statusItem = statusItem
            view.menu = statusMenu
            statusMenu.delegate = view
            return view
        }
        return NSView() as! StatusItemView
    }
    
    override func mouseDown(with event: NSEvent) {
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
