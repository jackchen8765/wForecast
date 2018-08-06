//
//  WeatherDownloader.swift
//  wForecast
//
//  Created by Liangzan Chen on 12/14/17.
//  Copyright © 2017 Jack Chen. All rights reserved.
//

import UIKit
import CoreLocation
import CZWeatherKit


class WeatherDownloader: NSObject{

    //MARK: Private

    private var geocoder = CLGeocoder()
    private var apiKey: String

    
    init(apiKey:  String) {
        self.apiKey = apiKey
        super.init()
    }
    
    private func executeRequest(_ request: CZWundergroundRequest,
                                _ city: String,
                                _ state: String,
                                _ completionHandler: @escaping (_ data: CZWeatherData?, _ error: Error?) -> Void) {
        let service = CZWeatherService(configuration: URLSessionConfiguration.default, key: self.apiKey)
        let location = CZWeatherLocation(fromCity: city, state: state)
        
        if let service = service {
            request.location = location
            request.key = self.apiKey
            service.dispatchRequest(request, completion: completionHandler)
        }
    }
    
    
    public func getCurrentCondition(city: String, state: String, completionHandler: @escaping (_ data: CZWeatherData?, _ error: Error?) -> Void) {
        //let service = CZWeatherService(configuration: URLSessionConfiguration.default, key: self.apiKey)
        
        if let request = CZWundergroundRequest.newConditions() {
            self.executeRequest(request, city, state, completionHandler)
        }
        
        /*
        let location = CZWeatherLocation(fromCity: city, state: state)
        
        if let service = service, let request = request {
            request.location = location
            request.key = self.apiKey
            service.dispatchRequest(request, completion: completionHandler)
        }
        */
    }
    
    public func get10DayForecast(city: String, state: String, completionHandler: @escaping (_ data: CZWeatherData?, _ error: Error?) -> Void) {
        if let request = CZWundergroundRequest.newForecast10Day() {
            self.executeRequest(request, city, state, completionHandler)
        }
        /*
        let service = CZWeatherService(configuration: URLSessionConfiguration.default, key: self.apiKey)
        let request = CZWundergroundRequest.newForecast10Day()
        let location = CZWeatherLocation(fromCity: city, state: state)
        if let service = service, let request = request {
            request.location = location
            request.key = self.apiKey
            service.dispatchRequest(request, completion: completionHandler)
        }
        */
    }
    
    public func getNewForecast(city: String, state: String, completionHandler: @escaping (_ data: CZWeatherData?, _ error: Error?) -> Void) {
        if let request = CZWundergroundRequest.newForecast() {
            self.executeRequest(request, city, state, completionHandler)
        }
        /*
        let service = CZWeatherService(configuration: URLSessionConfiguration.default, key: self.apiKey)
        let request = CZWundergroundRequest.newForecast()
        let location = CZWeatherLocation(fromCity: city, state: state)
        if let service = service, let request = request {
            request.location = location
            request.key = self.apiKey
            service.dispatchRequest(request, completion: completionHandler)
        } */
    }
    
    public func getHourlyForecast(city: String, state: String, completionHandler: @escaping (_ data: CZWeatherData?, _ error: Error?) -> Void) {
        let service = CZWeatherService(configuration: URLSessionConfiguration.default, key: self.apiKey)
        let request = CZWundergroundRequest.newHourly()
        let location = CZWeatherLocation(fromCity: city, state: state)
        if let service = service, let request = request {
            request.location = location
            request.key = self.apiKey
            service.dispatchRequest(request, completion: completionHandler)
        }
    }
}
