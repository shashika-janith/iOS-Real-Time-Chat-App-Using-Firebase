//
//  UIViewController.swift
//  ChatApp
//
//  Created by Sashika on 2/28/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class var storyBoardID: String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(appStoryBoard: AppStoryboard) -> Self {
        return appStoryBoard.viewController(viewControllerClass: self)
    }
    
}
