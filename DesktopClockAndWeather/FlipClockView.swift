//
//  FlipClockView.swift
//  DesktopClockAndWeather
//
//  Created by 徐卫 on 2018/10/29.
//  Copyright © 2018 xuwei. All rights reserved.
//

import Foundation
import WebKit


@IBDesignable
class FlipClockView: WKWebView,WKNavigationDelegate {

//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.loadClock()
//
//    }
    
    @IBInspectable open var ClockMode : UInt = 0
    
    func loadClock() -> Void {
        if let path = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "") {
            let fileUrl = URL(fileURLWithPath: path)
            self.loadFileURL(fileUrl, allowingReadAccessTo: fileUrl)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let string : String = "SetClockMode(" + String(ClockMode) + ")"
        print(string)
        self.evaluateJavaScript(string, completionHandler: { (any, error) in
            print(any)
            print(error)
        })
    }
    
   
    override func layout() {
        super.layout()
        self.loadClock()
    }
    
}
