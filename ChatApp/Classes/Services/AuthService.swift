//
//  AuthService.swift
//  ChatApp
//
//  Created by Sashika on 3/2/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static func signout() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch let err {
            debugPrint("Failed to signout \(err)")
            return false
        }
    }
    
}
