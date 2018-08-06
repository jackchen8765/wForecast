//
//  WeatherViewController.swift
//  wForecast
//
//  Created by Liangzan Chen on 12/16/17.
//  Copyright © 2017 Jack Chen. All rights reserved.
//

import UIKit
import CoreLocation
import CZWeatherKit

class WeatherViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    @IBOutlet weak var cityLabel: UILabel!
    

    
    var placeMark: CLPlacemark?
    
    var downloader: WeatherDownloader?
    
    var currTemperature: CFloat = 16.0
    var hourlyForecasts = [CZWeatherHourlyCondition]()
    var currentCondition: CZWeatherCurrentCondition?
    var dailyForecasts = [CZWeatherForecastCondition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.colors = [UIColor.white, UIColor.blue]
        self.view.layer.addSublayer(gradientLayer)
        // Do any additional setup after loading the view.
        if let place = self.placeMark {
            cityLabel.text = place.locality
            conditionLabel.text = "Clear"
            temperatureLabel.text = "20"
            imageView.image = UIImage(named: "snowy")
            
            if let key = AppInfo.getAPIKey(), let city = place.locality, let state = place.administrativeArea {
                downloader = WeatherDownloader.init(apiKey: key)
                //downloader?.getCurrentCondition(city: city, state: state, completionHandler: currentConditionsHandler(_:_:))
                
                //downloader?.getHourlyForecast(city: city, state: state, completionHandler: hourlyForecastHandler(_:_:))
                
                //downloader?.getNewForecast(city: city, state: state, completionHandler: newForecastHandler(_:_:))
                
                //downloader?.get10DayForecast(city: city, state: state, completionHandler: tenDaysForecastHandler(_:_:))
            }
        }
        else {
            cityLabel.text = ""
    
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func currentConditionsHandler(_ data: CZWeatherData?, _ error: Error?) {
        if let data = data {
            let current = data.current.summary
            unowned let unownedSelf = self
            DispatchQueue.main.async {
                unownedSelf.conditionLabel.text = current
            }
        }
    }
    
    func tenDaysForecastHandler(_ data: CZWeatherData?, _ error: Error?){
        if let data = data {
            let current = data.dailyForecasts
            unowned let unownedSelf = self
            DispatchQueue.main.async {
                unownedSelf.conditionLabel.text = "10day"
            }
        }
    }
    
    func hourlyForecastHandler(_ data: CZWeatherData?, _ error: Error?){
        if let data = data {
            let current = data.hourlyForecasts
            unowned let unownedSelf = self
            DispatchQueue.main.async {
                unownedSelf.conditionLabel.text = "hourly"
            }
        }
    }
    
    func newForecastHandler(_ data: CZWeatherData?, _ error: Error?){
        if let data = data {
            let current = data.current
            unowned let unownedSelf = self
            DispatchQueue.main.async {
                unownedSelf.conditionLabel.text = "newForecast"
            }
        }
    }

}
