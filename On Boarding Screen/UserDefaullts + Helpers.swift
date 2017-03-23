//
//  UserDefaullts + Helpers.swift
//  On Boarding Screen
//
//  Created by Matt Houston on 10/7/16.
//  Copyright © 2016 On Boarding Screen. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    //makes the string safer
    enum UserDefaultsKeys: String {
        case isLoggedIn
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
}
