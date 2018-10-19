//
//  CnWeater.swift
//  DesktopClockAndWeather
//
//  Created by xuwei on 2018/10/19.
//  Copyright © 2018年 xuwei. All rights reserved.
//

import Foundation
import Alamofire

class CnWeather {
    var timer: Timer? = nil
    
    
    func getWeatherInfo() {
        let url = "http://wthrcdn.etouch.cn/WeatherApi?citykey=101180101"
        
        Alamofire.request(url).responseJSON {
            resp in //method defaults to `.get`
            debugPrint(resp.request) // 返回请求URL
            debugPrint(resp.result) // 返回是否成功
            debugPrint(resp.value) // 返回请求成功数据
            debugPrint(resp.data)
       
        }
    }
}
