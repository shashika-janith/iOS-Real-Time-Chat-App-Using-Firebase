//
//  UserData.swift
//  ChatApp
//
//  Created by Sashika on 3/2/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation

class UserData {
    
    enum key: String {
        case username
        case userID
    }

    private static var defaults = UserDefaults.standard
    
    private class func saveStringValue(value: String, key: String) {
        defaults.set(value, forKey: key)
    }
    
    private class func getStringValue(forKey key: String) -> String? {
        return defaults.string(forKey: key)
    }
    
    // MARK: - Save user data
    
    public class func saveUsername(value: String) {
        saveStringValue(value: value, key: key.username.rawValue)
    }
    
    public class func saveUserID(value: String) {
        saveStringValue(value: value, key: key.userID.rawValue)
    }
    
    // MARK: - Get user data
    
    public class func getUsername(value: String) -> String? {
        return getStringValue(forKey: key.username.rawValue)
    }
    
    public class func getUserID(value: String) -> String? {
        return getStringValue(forKey: key.userID.rawValue)
    }
    
    public class func removeValue(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    public class func clearUserData() {
        defaults.dictionaryRepresentation().forEach({key, value in
            debugPrint("Removing user data for key: \(key)")
            removeValue(forKey: key)
        })
    }
    
}
