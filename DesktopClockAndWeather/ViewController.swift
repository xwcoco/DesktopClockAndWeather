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
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var dotImage: NSImageView!
    var timer: Timer? = nil
    var showDot: Bool = true
    var cnWeather = CnWeather()
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
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH mm"
//        self.timeLabel.stringValue = dateFormatter.string(from: currentDate)
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
       
        cnWeather.getWeatherInfo()

    }
    
    @objc dynamic func timerAction() {
        if self.showDot {
            self.dotImage.isHidden = true
            self.showDot = false
        } else {
            self.dotImage.isHidden = false
            self.showDot = true
        }
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH mm"
        self.timeLabel.stringValue = dateFormatter.string(from: currentDate)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            
            
        }
    }


}

