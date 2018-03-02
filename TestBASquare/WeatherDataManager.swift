//
//  WeatherDataManager.swift
//  TestBASquare
//
//  Created by Petro Novosad on 3/2/18.
//  Copyright © 2018 Petro Novosad. All rights reserved.
//
//=============================================================================================

import Foundation

///////////////////////////////////////////////////////////////////////////////////////////////
//    global variable
//      Notification name
//---------------------------------------------------------------------------------------------
public let WeatherDateNotification: String = "WeatherDateNotification"

///////////////////////////////////////////////////////////////////////////////////////////////
//    global variable
//      Notification name
//---------------------------------------------------------------------------------------------
public let WeatherDateNotAvailableNotification: String = "WeatherDateNotAvailableNotification"


//=============================================================================================
//
//     struct WeatherData
//
//=============================================================================================

struct WeatherData
{
    var temperatureCelsius: Double
}

//==== struct WeatherData =====================================================================



//=============================================================================================
//
//     class WeatherDataManager
//
//=============================================================================================

class WeatherDataManager
{
    //---------------------------------------------------------------------------------------------
    
    func receiveWeather(for city: String)
    {
        if let _city = city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        {
            OpenWeatherMapKit.instance.currentWeather(forCity: _city) { (weatherItem, error) in
                
                if weatherItem != nil
                {
                    DispatchQueue.main.async {
                        
                        // TODO: use appropriate way to get string
                        let tempStr: String = String(Int(round(weatherItem!.celsius.currentTemp))) + " ℃"
                        let dictionary: [String: Any] = ["city": city,
                                                         "temperatureCelsius": tempStr]
                        NotificationCenter.default.post(name: Notification.Name(rawValue: WeatherDateNotification), object: nil, userInfo: dictionary)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: WeatherDateNotAvailableNotification), object: nil, userInfo: nil)
                    }
                }
            }
        }
        else
        {
            assert(false)
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    static let instance: WeatherDataManager = {
        let sharedInstance = WeatherDataManager()
        return sharedInstance
    } ()
    
    //---------------------------------------------------------------------------------------------
    
    private init()
    {
        
    }
    
    //---------------------------------------------------------------------------------------------
}

//==== class WeatherDataManager ===============================================================


