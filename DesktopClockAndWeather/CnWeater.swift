//
//  CnWeater.swift
//  DesktopClockAndWeather
//
//  Created by xuwei on 2018/10/19.
//  Copyright © 2018年 xuwei. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyXMLParser


protocol CnWeatherProtocol {
    func showWeather(_ data:CnWeatherData)
}

class CnWeather {
    var timer: Timer? = nil
    var xml : XML.Accessor? = nil
    
    var delegate: CnWeatherProtocol?
    
    func beginTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1800,
                                     target: self,
                                     selector: #selector(getWeatherInfo),
                                     userInfo: nil,
                                     repeats: true)
        self.getWeatherInfo()

    }
    
    @objc func getWeatherInfo() {
        let url = "http://wthrcdn.etouch.cn/WeatherApi?citykey=101180101"
        
        Alamofire.request(url).responseString {
            resp in //method defaults to `.get`
//            debugPrint(resp.request) // 返回请求URL
//            debugPrint(resp.result) // 返回是否成功
//            debugPrint(resp.value) // 返回请求成功数据
//            debugPrint(resp.data)

            if resp.result.isSuccess {
                print("ok")
                self.xml = try! XML.parse(resp.data!)
                
                self.getWeatherData()
                
            }
       
        }
    }
    
    func getWeatherData() {
        if (self.xml != nil) {
            print("xmlok")
            let data = CnWeatherData()
            
            if let city = self.xml?["resp","city"].text {
                data.City = city
            }
            
            if let updatetime = self.xml?["resp","updatetime"].text {
                data.UpdateTime = updatetime
            }
            if let wendu = self.xml?["resp","wendu"].text {
                data.Wendu = wendu
            }
            if let fengli = self.xml?["resp","fengli"].text {
                data.fengli = fengli
            }
            if let shidu = self.xml?["resp","shidu"].text {
                data.shidu = shidu
            }
            if let fengxiang = self.xml?["resp","fengxiang"].text {
                data.fengxiang = fengxiang
            }
            
            if let aqi = self.xml?["resp","environment","aqi"].text {
                data.aqi = aqi
            }
            if let pm25 = self.xml?["resp","environment","pm25"].text {
                data.pm25 = pm25
            }
            
            if let pm10 = self.xml?["resp","environment","pm10"].text {
                data.pm10 = pm10
            }
            
            if let suggest = self.xml?["resp","environment","suggest"].text {
                data.suggest = suggest
            }
            
            if let quality = self.xml?["resp","environment","quality"].text {
                data.quality = quality
            }
            
            
            
            if let dayType = self.xml?["resp","forecast","weather",0,"day","type"].text {
                data.dayType = dayType
            }
            if let night = self.xml?["resp","forecast","weather",0,"night","type"].text {
                data.nightType = night
            }
            
            let date = Date()
            let calendar = NSCalendar.current
            //        let nsDateComponents = calendar.dateComponents(in: calendar.timeZone, from: currentDate)
            let hour = calendar.component(.hour, from: date)
            if (hour >= 6 && hour <= 18) {
                data.type = data.dayType
            } else {
                data.type = data.nightType
            }
            if let high = self.xml?["resp","forecast","weather",0,"high"].text {
                data.high = high
//                print("high = "+high)
            }
            if let low = self.xml?["resp","forecast","weather",0,"low"].text {
                data.low = low
            }

            
            
//            if let yundong_name = self.xml?["resp","zhishus","zhishu",8,"name"].text {
//                data.yundong_zishu = yundong_name
//            }
//            if let yundong_value = self.xml?["resp","zhishus","zhishu",8,"value"].text {
//                data.yundong_value = yundong_value
//            }
//            if let yundong_detail = self.xml?["resp","zhishus","zhishu",8,"detail"].text {
//                data.yundong_detail = yundong_detail
//            }

            data.zhishu = []
            
            var index : Int = 0
            
            if let zhishus = self.xml?["resp","zhishus","zhishu"] {
                for item in zhishus {
                    
//                    print(item)
                    
                    var zhi =  CnWeatherData.zhishu_struct()
                    if let tmpStr = self.xml?["resp","zhishus","zhishu",index,"name"].text {
                        zhi.name = tmpStr
                    }
                    
                    index = index + 1
//                    if let tmpStr = item.childElements[0].text {
//                        zhi.name = tmpStr
//                    }
                    
                    

                    if let tmpValue = item.value.text {
                        zhi.value = tmpValue
                    }

                    if let tmpDetail = item.detail.text {
                        zhi.detail = tmpDetail
                    }
                    data.zhishu.append(zhi)
                }
                
            }


            for list in data.zhishu {
                print(list)
            }
            
            print("update weather...")
            delegate?.showWeather(data)
            
        }
    }
}
