//
//  ViewController.swift
//  DesktopClockAndWeather
//
//  Created by xuwei on 2018/10/18.
//  Copyright © 2018年 xuwei. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {

    @IBOutlet weak var weekLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentDate = Date()

        //let calendar = Calendar.current
        
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd"
//        let day = dateFormatter.string(from: currentDate)
        
        let calendar = NSCalendar.current
//        let nsDateComponents = calendar.dateComponents(in: calendar.timeZone, from: currentDate)
        let weekday = calendar.component(.weekday, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        let weeks:[String] = ["星期天","星期一","星期二","星期三","星期四","星期五","星期六"]
        self.weekLabel.stringValue = weeks[weekday-1]
//        let todayDate = NSDateComponents()
//        let day = todayDate.day
        self.dateLabel.stringValue = String(day)
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            
            
        }
    }


}

