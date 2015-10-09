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
    
    init(value: String){
        switch value{
        case "clear-day":
            self = .ClearDay
        case "clear-night":
            self = .ClearNight
        case "rain":
            self = .Rain
        case "snow":
            self = .Snow
        case "sleet":
            self = .Sleet
        case "wind":
            self = .Wind
        case "fog":
            self = .Fog
        case "cloudy":
            self = .Cloudy
        case "partly-cloudy-day":
            self = .PartlyCloudyDay
        case "partly-cloudy-night":
            self = .PartlyCloudyNight
        default:
            self = .ClearDay
        }
    }
}

struct BTDailyForecast {
    var precipitationProbability : Double
    var weatherIcon : WeatherIcon
    var maxTemperature : Double    
}