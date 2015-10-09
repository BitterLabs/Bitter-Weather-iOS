//
//  BTWeatherAPI.swift
//  Bitter-Weather-iOS
//
//  Created by Harnek Sidhu on 2015-09-21.
//  Copyright © 2015 Bitter Labs. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

protocol BTWeatherAPIDelegate : class{
    func dailyForecastDidUpdate(dailyForecast: Array<BTDailyForecast>)
}

class BTWeatherAPI : NSObject, CLLocationManagerDelegate{

    private let forecastIOBaseURL="https://api.forecast.io/forecast/6a9ccdc5e3b24ef6db129a02a433b42d/%@,%@?units=%@"
    
    private var clManager:CLLocationManager
    
    private var queryCelsius = false
    
    private var latitude: Double?
    private var longitude: Double?
    
    private weak var delegate: BTWeatherAPIDelegate?
    
    init?(delegate: BTWeatherAPIDelegate){
        clManager = CLLocationManager()
        self.delegate = delegate
        super.init()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Restricted || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied){
            return nil
        }
        clManager.delegate = self
        clManager.requestWhenInUseAuthorization()
    }
    
    func getForecast(celsius: Bool){
        self.queryCelsius = celsius
        clManager.requestLocation()
    }
    
    private func getJSONResponseFromURL(url: String, completionHandler: (JSON) -> Void){
        if let nsURL = NSURL(string: url){
            let httpTask = NSURLSession.sharedSession().dataTaskWithURL(nsURL) {(data, response, error) in
                if error == nil && data != nil{
                    let jsonResponse = JSON(data: data!)
                    completionHandler(jsonResponse)
                }
            }
            httpTask.resume()
        }
    }
    
    private func getForecastFromForecastIO(celsius: Bool){
        if latitude != nil && longitude != nil{
            var args = [CVarArgType]()
            args.append(String(latitude!))
            args.append(String(longitude!))
            if celsius{
                args.append("si")
            }else{
                args.append("us")
            }
            let httpQuery = String(format: forecastIOBaseURL, arguments: args)
            
            getJSONResponseFromURL(httpQuery){(jsonResponse: JSON) in
                var dailyForecast = Array<BTDailyForecast>()
                let temperatureDataArray = jsonResponse["daily"]["data"]
                for (_,temperatureData):(String, JSON) in temperatureDataArray {
                    
                    let precipitationProbability = temperatureData["precipProbability"].double
                    let weatherIcon = temperatureData["icon"].string
                    let maxTemperature = temperatureData["temperatureMax"].double
                    if precipitationProbability != nil && weatherIcon != nil && maxTemperature != nil{
                        let btDailyForecast = BTDailyForecast(precipitationProbability:precipitationProbability!, weatherIcon: WeatherIcon(value: weatherIcon!), maxTemperature: maxTemperature!)
                        
                        dailyForecast.append(btDailyForecast)
                        
                    }
                    
                }                
                self.delegate?.dailyForecastDidUpdate(dailyForecast)
            }
        }
    }
    
     func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let currentLocation = locations.last{
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
            getForecastFromForecastIO(self.queryCelsius)
        }
    }
    
     func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("locationManager failed")
    }
    
}