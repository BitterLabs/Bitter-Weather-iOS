//
//  ViewController.swift
//  Bitter-Weather-iOS
//
//  Created by Harnek Sidhu on 2015-09-21.
//  Copyright © 2015 Bitter Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var btWeatherAPI: BTWeatherAPI

    required init(coder aDecoder: NSCoder) {
        btWeatherAPI = BTWeatherAPI()
        super.init(coder: aDecoder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btWeatherAPI.getForecast(latitude: 43.7000, longitude: 79.4000, celsius: true)
        print(WeatherIcon.ClearDay)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

