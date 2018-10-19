//
//  PrefsViewController.swift
//  DesktopClockAndWeather
//
//  Created by xuwei on 2018/10/19.
//  Copyright © 2018年 xuwei. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyXMLParser

class PrefsViewController: NSViewController {

    @IBAction func shengChanged(_ sender: NSComboBox) {
        
    }
    @IBOutlet weak var shengCombox: NSComboBox!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        self.getWeatherCN()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    open func getWeatherCN() {
        
        let url = "http://flash.weather.com.cn/wmaps/xml/china.xml"
        Alamofire.request(url).responseString {
            resp in //method defaults to `.get`
            if resp.result.isSuccess {
                let xml = try! XML.parse(resp.data!)
                let list = xml["china","city"]
                for item in list {
                    self.shengCombox.addItem(withObjectValue: item.attributes["quName"])
//                    print(item)
//                    print(item.attributes["quName"])
                }
                
                
            }
            
        }

    }

}
