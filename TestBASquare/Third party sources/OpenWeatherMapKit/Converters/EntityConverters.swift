//
//  EntityConverters.swift
//  OpenWeatherMapKit
//
//  Created by Anver Bogatov on 29.12.2017.
//  Copyright © 2017 Anver Bogatov. All rights reserved.
//

import Foundation

internal enum SupportedType {
    case weatherForceast, weatherItem
}

internal protocol EntityConverter {

    func convert(entity: Data) -> BasicItem?

}

internal class WeatherItemConverter: EntityConverter {

    func convert(entity: Data) -> BasicItem? {

        let jsonData = try? JSONSerialization.jsonObject(with: entity, options: .mutableContainers) as! NSDictionary
        var result: WeatherItem?

        if let jsonData = jsonData {
            let weatherStats = jsonData["main"] as! NSDictionary
            let t = weatherStats["temp"] as! Double
            let tMax = weatherStats["temp_max"] as! Double
            let tMin = weatherStats["temp_min"] as! Double
            
            //========================================================
            let cloudsStats = jsonData["clouds"] as! NSDictionary
            let cloudiness = cloudsStats["all"] as! Int32
            
            let descriptionStats = jsonData["weather"] as? NSArray
            let descriptionStatsFirstElem = descriptionStats?[0] as? NSDictionary
            let descriptionID = (descriptionStatsFirstElem?["id"] as? Int32) ?? 0
            //debugPrint("descriptionID: \(descriptionID)")
            
            let descriptionStr: String
            
            // More detailed information is on https://openweathermap.org/weather-conditions
            switch descriptionID
            {
                case 200 ... 232
                    : descriptionStr = "thunderstorm"
                
                case 310, // light intensity drizzle rain
                     311, // drizzle rain
                     312, // heavy intensity drizzle rain
                     313, //  shower rain and drizzle
                     314, // heavy shower rain and drizzle
                     321, //  shower drizzle
                     500, // light rain
                     501, // moderate rain
                     520, // light intensity shower rain
                     521, // shower rain
                     531  // ragged shower rain
                    : descriptionStr = "rain"
                
                case 502, // heavy intensity rain
                     503, // very heavy rain
                     504, // extreme rain
                     522  // heavy intensity shower rain
                    : descriptionStr = "heavy-rain"
                
                case 600 // light snow
                    : descriptionStr = "scattered-snow"
                
                case 601, // snow
                     602  // heavy snow
                    : descriptionStr = "snow"
                
                case 611 // sleet
                    : descriptionStr = "snow-sleet"
                
                case 511, // freezing rain
                     612 ... 621
                    : descriptionStr = "hail"
                
                case 622  // heavy shower snow
                    : descriptionStr = "blowing-snow"
                
                case 701, // mist
                     711, // smoke
                     721  // haze
                    : descriptionStr = "smoke"
                
                case 731, // sand, dust whirls
                     751, // sand
                     761  // dust
                    : descriptionStr = "dust"
                
                case 300, // light intensity drizzle
                     301, // drizzle
                     302, // heavy intensity drizzle
                     741  // fog
                    : descriptionStr = "fog"
                
                case 800 // clear sky
                    : descriptionStr = "sunny"
                
                case 801, // few clouds
                     802  // scattered clouds
                    : descriptionStr = "partly-sunny"
                
                case 803, // broken clouds
                     804  // overcast clouds
                    : descriptionStr = "cloudy"
                
                default: descriptionStr = ""
            }
            
            //========================================================
            
            result = WeatherItem(currentTemp: t,
                    maxTemp: tMax,
                    minTemp: tMin,
                    //========================================================
                    cloudiness: cloudiness,
                    descriptionStr: descriptionStr
                    //========================================================
                    )
        }

        return result
    }

}

internal final class NopConverter: EntityConverter {

    func convert(entity: Data) -> BasicItem? {
        return nil
    }

}

internal final class EntityConverterFactory {

    class func makeConverter(for type: SupportedType) -> EntityConverter {
        switch type {
        case .weatherItem:
            return WeatherItemConverter()
        default:
            return NopConverter()
        }
    }

}
