//
//  TitleLabel.swift
//  DesktopClockAndWeather
//
//  Created by 徐卫 on 2018/10/30.
//  Copyright © 2018 xuwei. All rights reserved.
//

import Foundation
import AppKit

class TitleLabel: NSView {
    
    private var title : NSTextView  = NSTextView()
    
    private var label : NSTextView = NSTextView()
    
    private var TitleFontSize : UInt = 18
    
    private var LabelFontSize : UInt = 14
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)

        self.initLables()
    }
    
    private func initLables() {
        self.backgroundColor = NSColor.clear
        
//        self.isOpaque = false
        
        title.isEditable = false
        title.isSelectable = false
        title.backgroundColor = NSColor.black
        title.textColor = NSColor.white
        title.drawsBackground = false
        
        
        title.font = NSFont(name: "Monaco", size: CGFloat(self.TitleFontSize))
        
        label.isEditable = false
        label.isSelectable = false
        label.backgroundColor = NSColor.black
        label.textColor = NSColor.white
        label.font = NSFont(name: "Monaco", size: CGFloat(self.LabelFontSize))

        label.drawsBackground = false
       
        addSubview(title)
        addSubview(label)

    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.initLables()
    }
    
    
    override func layout() {
        super.layout();
        let titleFrame : NSRect = NSRect(x: 0, y: bounds.height * 2 / 3, width: bounds.width, height: bounds.height / 3)
        let labelFrame : NSRect = NSRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 2 / 3)
        
        self.title.frame = titleFrame
        self.label.frame = labelFrame
    }
    
    public func setText(title titleString : String,label text : String) -> Void {
        self.title.string = titleString
        self.label.string = text
    }
}
