//
//  MyWindowControl.swift
//  DesktopClockAndWeather
//
//  Created by xuwei on 2018/10/23.
//  Copyright © 2018年 xuwei. All rights reserved.
//

import Foundation
import AppKit

class MyWindowControl : NSWindowController,NSWindowDelegate {
    override func windowDidLoad() {
        super.windowDidLoad()
        
//        if let thewindow = window {
//            thewindow.setFrameUsingName("MyWindow")
//            self.windowFrameAutosaveName = "MyWindow"
//        }
        
        window?.delegate = self
        
        if let info : String = UserDefaults.standard.value(forKey: "windowpos") as! String {
            let rect : NSRect = NSRectFromString(info)
            window?.setFrame(rect, display: true, animate: true)
//            window?.frame = NSRect
            print(info)
        }
        /// restore position
    }
    
    func windowWillClose(_ notification: Notification) {
        if let rect : NSRect = window?.frame {
            let string : String = NSStringFromRect(rect)
            
            print(string)
            
            UserDefaults.standard.set(string, forKey: "windowpos")
            
//            UserDefaults.standard.synchronize()
            
        }
    }
    
    
//    override func close() {
//
//
//
//        super.close()
//    }
    
    
}
