//
//  UserPreference.swift
//  wForecast
//
//  Created by Liangzan Chen on 12/17/17.
//  Copyright © 2017 Jack Chen. All rights reserved.
//

import UIKit
import CoreLocation

class UserPreference: NSObject {
    // MarK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("placeMarks")
    
    static func getPlaceMarks() -> [CLPlacemark]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserPreference.ArchiveURL.path) as? [CLPlacemark]
    }
    
    static func savePlaceMarks(_ placeMarks: [CLPlacemark]) {
        NSKeyedArchiver.archiveRootObject(placeMarks, toFile: UserPreference.ArchiveURL.path)
    }
    
    static func getCurrentPlaceMarkIndex() -> Int {
        return UserDefaults.standard.integer(forKey: "currentPlaceMarkIndex")
    }
    
    static func setCurrentPlaceMarkIndex(_ currIndex: Int) {
        if currIndex != UserPreference.getCurrentPlaceMarkIndex() {
            UserDefaults.standard.set(currIndex, forKey: "currentPlaceMarkIndex")
            UserDefaults.standard.synchronize()
        }
    }
}
