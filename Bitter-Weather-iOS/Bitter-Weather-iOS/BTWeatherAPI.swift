//
//  BTWeatherAPI.swift
//  Bitter-Weather-iOS
//
//  Created by Harnek Sidhu on 2015-09-21.
//  Copyright © 2015 Bitter Labs. All rights reserved.
//

import Foundation
import CoreLocation

protocol BTWeatherAPIDelegate{
    func dailyForecastDidUpdate(dailyForecast: Array<BTDailyForecast>)
}

class BTWeatherAPI : NSObject, CLLocationManagerDelegate{

    let forecastIOBaseURL="https://api.forecast.io/forecast/6a9ccdc5e3b24ef6db129a02a433b42d/%@,%@?units=%@"
    
    var clManager:CLLocationManager
    
    var latitude: Double?
    var longitude: Double?
    
    var delegate: BTWeatherAPIDelegate
    
    init?(delegate: BTWeatherAPIDelegate){
        clManager = CLLocationManager()
        self.delegate = delegate
        super.init()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Restricted || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied){
            return nil
        }
        clManager.delegate = self
        clManager.requestWhenInUseAuthorization()
        clManager.requestLocation()
    }
    
    func convertDataToNSDictionary(data: NSData) -> NSDictionary?{
        do{
            let dataDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? NSDictionary
            return dataDictionary
        }catch{
            
        }
        
        return nil
    }
    
    func getJSONResponseFromURL(url: String, completionHandler: (NSDictionary) -> Void){
        
        if let nsURL = NSURL(string: url){
            let httpTask = NSURLSession.sharedSession().dataTaskWithURL(nsURL) {(data, response, error) in
                if error == nil && data != nil{
                    if let jsonResponse = self.convertDataToNSDictionary(data!){
                        completionHandler(jsonResponse)
                    }
                }
            }
            httpTask.resume()
        }
    }
    
    func getForecast(celsius: Bool, completionHandler: (dailyForecast: Array<BTDailyForecast>) -> Void){
  //      if longitude == nil || latitude == nil{
//            return nil
            latitude = 43.7000
            longitude = 79.4000
//        }else{
            var args = [CVarArgType]()
            args.append(String(latitude!))
            args.append(String(longitude!))
            if celsius{
                args.append("si")
            }else{
                args.append("us")
            }
            let httpQuery = String(format: forecastIOBaseURL, arguments: args)
        
            getJSONResponseFromURL(httpQuery){(jsonResponse: NSDictionary) in
                if let temperatureDataArray = jsonResponse.objectForKey("daily")?.objectForKey("data") as? Array<NSDictionary>{
                    var dailyForecast = Array<BTDailyForecast>()
                    for temperatureData in temperatureDataArray{
                        let precipitationProbability = temperatureData.objectForKey("precipProbability") as? Double
                        let weatherIcon = temperatureData.objectForKey("icon") as? String
                        
                        let maxTemperature = temperatureData.objectForKey("temperatureMax") as? Double
                        
                        if precipitationProbability != nil && weatherIcon != nil && maxTemperature != nil{
                            
                            let btDailyForecast = BTDailyForecast(precipitationProbability:precipitationProbability!, weatherIcon: WeatherIcon(value: weatherIcon!), maxTemperature: maxTemperature!)
                            
                            dailyForecast.append(btDailyForecast)
   
                        }
                    }
                    completionHandler(dailyForecast: dailyForecast)

                }
                
            }
        
        
     //   }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let currentLocation = locations.last{
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("locationManager failed")
    }
    
}