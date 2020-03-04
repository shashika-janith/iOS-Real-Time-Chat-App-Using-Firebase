//
//  AuthViewController.swift
//  ChatApp
//
//  Created by Sashika on 2/27/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtFieldUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTappedSignInBtn(_ sender: Any) {
        let name = txtFieldUsername.text
        
        if !(name?.isEmpty ?? true) {
            debugPrint(name!)
            
            txtFieldUsername.resignFirstResponder()
            Auth.auth().signInAnonymously(completion: { result, error in
                if result?.user != nil, let user = result?.user {
                    UserData.saveUsername(value: name!)
                    UserData.saveUserID(value: user.uid)
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    
                    appDelegate.show()
                } else {
                    debugPrint(error.debugDescription)
                }
                
            })
        } else {
            Alerts.showErrorAlert(message: Strings.Messages.emptyUsername)
        }
        
    }
}
