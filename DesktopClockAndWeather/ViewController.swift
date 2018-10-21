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
    
    @IBOutlet weak var minuteLabel: FlapLabel!
    @IBOutlet weak var hourLabel: FlapLabel!
    
    @IBOutlet weak var dateLabel: FlapLabel!
    
    @IBOutlet weak var dotImage: NSImageView!
    @IBOutlet weak var cityLabel: NSTextField!
    @IBOutlet weak var updateTimeLabel: NSTextField!
    @IBOutlet weak var wenduLabel: NSTextField!
    @IBOutlet weak var fengLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var aqiLabel: NSTextField!
    @IBOutlet weak var suggestLabel: NSTextField!
    @IBOutlet weak var yundongLabel: NSTextField!
    @IBOutlet weak var yundongDetalLabel: NSTextField!
    @IBOutlet weak var highLabel: NSTextField!
    @IBOutlet weak var lowLabel: NSTextField!
    
    @IBOutlet weak var WeatherIcon: NSImageView!
    
    var timer: Timer? = nil
    var showDot: Bool = true
    var cnWeather = CnWeather()
    var oldDay: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.updateDateAndWeek()
        
       
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
        
        cnWeather.delegate = self
       
        cnWeather.beginTimer()
//        cnWeather.getWeatherInfo()

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
        dateFormatter.dateFormat = "HH"
        self.hourLabel.setText(dateFormatter.string(from: currentDate), animated: true)
        dateFormatter.dateFormat = "mm"
        self.minuteLabel.setText(dateFormatter.string(from: currentDate), animated: true)
//        self.timeLabel.setText(dateFormatter.string(from: currentDate), animated: true)
//        self.timeLabel.stringValue = dateFormatter.string(from: currentDate)
        
        let calendar = NSCalendar.current
        let day = calendar.component(.day, from: currentDate)
        if (day != self.oldDay) {
            self.updateDateAndWeek()
        }

    }
    
    func updateWeatherIcon(data: CnWeatherData) {
        var code = "01"
        switch data.type {
        case "晴":
            code = "01"
        case "多云":
            code = "02"
        case "阴":
            code = "03"
        case "阵雨":
            code = "04"
        case "雷阵雨":
            code = "05"
        case "雷阵雨伴有冰雹":
            code = "06"
        case "雨夹雪":
            code = "07"
        case "小雨":
            code = "08"
        case "中雨":
            code = "09"
        case "大雨":
            code = "13"
        case "暴雨":
            code = "14"
            
        case "大暴雨":
            code = "15"
        case "特大暴雨":
            code = "16"
        case "阵雪":
            code = "17"
        case "小雪":
            code = "18"
        case "中雪":
            code = "19"
        case "大雪":
            code = "20"
        case "暴雪":
            code = "21"
        case "雾":
            code = "25"
        case "冻雨":
            code = "26"
        case "沙尘暴":
            code = "27"
            
        case "小到中雨":
            code = "28"
        case "中到大雨":
            code = "29"
        case "大到暴雨":
            code = "30"
        case "暴雨到大暴雨":
            code = "31"
        case "大暴雨到特大暴雨":
            code = "32"
        
        case "小到中雪":
            code = "33"
        case "中到大雪":
            code = "37"
        case "大到暴雪":
            code = "38"
        case "浮尘":
            code = "39"
        case "扬沙":
            code = "40"
        case "强沙尘暴":
            code = "41"
        case "雨":
            code = "42"
        case "雪":
            code = "43"
        case "霾":
            code = "44"
        default:
            code = "01"
        }
        let name = "white_"+code
        print(name)
        self.WeatherIcon.image = NSImage(named: name)
        
    }
    
    func updateDateAndWeek(){
        let currentDate = Date()
        let calendar = NSCalendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        let weeks:[String] = ["星期天","星期一","星期二","星期三","星期四","星期五","星期六"]
        self.weekLabel.stringValue = weeks[weekday-1]
        dateLabel.setText(String(day), animated: true)
//        self.dateLabel.stringValue = String(day)
        self.oldDay = day
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            
            
        }
    }
}

extension ViewController: CnWeatherProtocol {
    func showWeather(_ data: CnWeatherData) {
        print(data.fengli)
        self.cityLabel.stringValue = data.City
        self.updateTimeLabel.stringValue = "更新于 "+data.UpdateTime
        self.wenduLabel.stringValue = data.Wendu
        self.typeLabel.stringValue = data.dayType
        
        self.fengLabel.stringValue = data.fengxiang + " " + data.fengli + "   湿度:" + data.shidu
        self.aqiLabel.stringValue = data.aqi + "  " + data.quality + "     PM2.5  " + data.pm25
        self.suggestLabel.stringValue = data.suggest
        self.yundongLabel.stringValue = data.yundong_zishu + "  " + data.yundong_value
        self.yundongDetalLabel.stringValue = data.yundong_detail
        self.highLabel.stringValue = data.high
        self.lowLabel.stringValue = data.low
        self.updateWeatherIcon(data: data)
    }
    
    
}

