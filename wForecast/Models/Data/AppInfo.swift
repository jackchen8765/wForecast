//
//  AppInfo.swift
//  wForecast
//
//  Created by Liangzan Chen on 12/16/17.
//  Copyright © 2017 Jack Chen. All rights reserved.
//

import UIKit

class AppInfo: NSObject {
    static func getAPIKey() -> String? {
        if let infoPlist = Bundle.main.infoDictionary, let key = infoPlist["wuAPIKey"] as? String {
            return key
        }
        else {
            return nil
        }
    }
}
