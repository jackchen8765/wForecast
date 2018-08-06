//
//  AppDelegate.swift
//  wForecast
//
//  Created by Liangzan Chen on 12/14/17.
//  Copyright © 2017 Jack Chen. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PlaceMarkChangeDelegate {

    var window: UIWindow?
    
    var placeMarks : [CLPlacemark] = []
    var currPlaceMarkIndex = 0 

    //MARK: UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //read previous saved data
        self.readPlaceMark()
        
        if let homeViewController = window?.rootViewController as? HomeViewController {
            homeViewController.placeMarks = self.placeMarks
            homeViewController.delegate = self
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.savePlaceMark()
    }

    //MARK: Data Read and Write
    func readPlaceMark() {
        self.placeMarks = UserPreference.getPlaceMarks() ?? [CLPlacemark]()
        self.currPlaceMarkIndex = UserPreference.getCurrentPlaceMarkIndex()
    }
    
    func savePlaceMark() {
        UserPreference.savePlaceMarks(self.placeMarks)
        UserPreference.setCurrentPlaceMarkIndex(self.currPlaceMarkIndex)
    }
    
    func updateCurrentPlaceMarkIndex(_ index: Int) {
        self.currPlaceMarkIndex = index
        UserPreference.setCurrentPlaceMarkIndex(index)
    }
    
    func updatePlaceMarks(withPlaceMarks: [CLPlacemark]) {
        self.placeMarks = withPlaceMarks
        UserPreference.savePlaceMarks(self.placeMarks)
    }
    
    
    //MARK: PlaceMarkChangeDelegate
    func didAddPlaceMark(_ placeMark: CLPlacemark) {
        self.placeMarks .append(placeMark)
        self.savePlaceMark()
    }
    
    func didRemovePlaceMark(at: Int) {
        self.placeMarks.remove(at: at)
        self.savePlaceMark()
    }
   
}

