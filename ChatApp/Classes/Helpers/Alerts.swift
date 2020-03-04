//
//  Alerts.swift
//  ChatApp
//
//  Created by Sashika on 2/28/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation
import SwiftMessages

class Alerts {
    
    class func showErrorAlert(message: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(title: Strings.Alerts.titleError,
                              body: message,
                              iconImage: nil,
                              iconText: nil,
                              buttonImage: nil,
                              buttonTitle: Strings.AlertActions.close,
                              buttonTapHandler: {_ in SwiftMessages.hide() })
        
        SwiftMessages.show(view: view)
    }
}
