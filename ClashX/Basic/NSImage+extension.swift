//
//  NSImage+extension.swift
//  ClashX
//
//  Created by CYC on 2018/8/6.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {
    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        color.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)
        
        image.unlockFocus()
        image.isTemplate = false
        
        return image
    }
}
