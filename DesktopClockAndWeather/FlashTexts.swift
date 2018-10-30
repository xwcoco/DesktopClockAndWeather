//
//  FlashTexts.swift
//  DesktopClockAndWeather
//
//  Created by 徐卫 on 2018/10/30.
//  Copyright © 2018 xuwei. All rights reserved.
//

import Foundation
import AppKit

class FlashTexts: NSView {
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    public func clear() -> Void {
        self.subviews.removeAll()
        if (timer != nil) {
            timer?.invalidate();
            timer = nil
        }
    }
    
    func add(title Title : String,label text : String) -> Void {
        let view  : TitleLabel = TitleLabel(frame: self.bounds)
        view.setText(title: Title, label: text)
        view.alphaValue = 0
        self.addSubview(view)
    }
    
    private var curIndex : Int = 0
    
    var timer: Timer? = nil
    
    public func beginTimer() -> Void {
        if self.subviews.count <= 1 {
            return;
        }
        
        curIndex = -1
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        self.timerAction()
    }
    
    @objc dynamic func timerAction() {

        var view : NSView
        if (curIndex != -1) {
            view = self.subviews[curIndex]
            view.alphaValue = 0
        }
        
        curIndex = curIndex + 1
        if (curIndex == self.subviews.count) {
            curIndex = 0
        }
        
        view = self.subviews[curIndex]
        view.alphaValue = 1

    }
    
}
