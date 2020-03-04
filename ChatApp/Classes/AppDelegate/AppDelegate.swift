//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Sashika on 2/27/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var rootViewController: UIViewController? {
        didSet {
            if let vc = rootViewController {
                window?.rootViewController = vc
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        show()
        return true
    }

    // MARK: UISceneSession Lifecycle

    /*
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    */

}

extension AppDelegate {
    
    func show() {
        
        if Auth.auth().currentUser != nil {
            rootViewController = ChatAppNavigationController.instantiateFromAppStoryboard(appStoryBoard: .Chat)
            window?.makeKeyAndVisible()
        } else {
            rootViewController = LoginViewController.instantiateFromAppStoryboard(appStoryBoard: .Auth)
            window?.makeKeyAndVisible()
        }
        
    }
    
}
