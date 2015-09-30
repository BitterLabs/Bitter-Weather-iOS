//
//  BTWeatherAPI.swift
//  Bitter-Weather-iOS
//
//  Created by Harnek Sidhu on 2015-09-21.
//  Copyright © 2015 Bitter Labs. All rights reserved.
//

import Foundation
import CoreLocation

class BTWeatherAPI : NSObject, CLLocationManagerDelegate{
    
    let yahooBaseURL="https://query.yahooapis.com/v1/public/yql?"

    let yahooQuery="q=select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"%@\")&format=json"

    
    var clManager:CLLocationManager
    
    var city:String?
    
     override init(){
        let authorizationStatus=CLLocationManager.authorizationStatus()
        print(authorizationStatus.rawValue)
        clManager = CLLocationManager()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Restricted || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied){
            //TODO: Convert this initializer to failable
//            return nil
        }
        super.init()
        clManager.delegate = self
        clManager.requestWhenInUseAuthorization()
        clManager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("reached locationManager")
        
        let currentLocation=locations.last!
        
        
        let reverseGeocoder = CLGeocoder()
        reverseGeocoder.reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) ->Void in
            
            let cityLocale = placemarks?[0].locality
            
            if cityLocale != nil{
                self.city = cityLocale
            }
           
        })
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("locationManager failed")
    }
    
    func getForecast(){
        //tmporary
        self.city="Toronto"
        if ((self.city) != nil){
            let concatenatedQuery = String(format: yahooQuery, arguments: [self.city!])
            
            let escapedQuery = concatenatedQuery.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            
            print(escapedQuery)
            
            if let url = NSURL(string: yahooBaseURL+escapedQuery!){

                let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
                    let json=self.convertDataToDictionary(data!)!
                    
                }
                task.resume()

            }
            
        }
        
    }
    
    func convertDataToDictionary(data: NSData) -> [String:AnyObject]? {
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String:AnyObject]
                return json

            } catch let error as NSError{
                print(error.localizedDescription)
            }
            return nil
    }
    
    
}