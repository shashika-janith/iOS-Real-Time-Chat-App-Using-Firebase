//
//  AppStoryboard.swift
//  ChatApp
//
//  Created by Sashika on 2/28/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    
    case Chat, Auth
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyBoardID = (viewControllerClass as UIViewController.Type).storyBoardID
        return instance.instantiateViewController(withIdentifier: storyBoardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
