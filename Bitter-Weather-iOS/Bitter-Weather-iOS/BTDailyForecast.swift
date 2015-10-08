//
//  DailyForecast.swift
//  Bitter-Weather-iOS
//
//  Created by Harnek Sidhu on 2015-10-07.
//  Copyright © 2015 Bitter Labs. All rights reserved.
//

import Foundation

enum WeatherIcon{
    case ClearDay
    case ClearNight
    case Rain
    case Snow
    case Sleet
    case Wind
    case Fog
    case Cloudy
    case PartlyCloudyDay
    case PartlyCloudyNight
    
    func getIconFromValue(value: String) -> WeatherIcon{
        switch value{
            case "clear-day":
                return WeatherIcon.ClearDay
            case "clear-night":
                return WeatherIcon.ClearNight
            case "rain":
                return WeatherIcon.Rain
            case "snow":
                return WeatherIcon.Snow
            case "sleet":
                return WeatherIcon.Sleet
            case "wind":
                return WeatherIcon.Wind
            case "fog":
                return WeatherIcon.Fog
            case "cloudy":
                return WeatherIcon.Cloudy
            case "partly-cloudy-day":
                return WeatherIcon.PartlyCloudyDay
            case "partly-cloudy-night":
                return WeatherIcon.PartlyCloudyNight
            default:
                return WeatherIcon.ClearDay
        }
    }
}

struct BTDailyForecast {
    var precipitationProbability : Double
    var weatherIcon : WeatherIcon
    
    
}