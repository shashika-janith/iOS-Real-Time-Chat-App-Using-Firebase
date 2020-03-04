//
//  Strings.swift
//  ChatApp
//
//  Created by Sashika on 2/28/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation

struct Strings {
    
    struct NewChannelAlert {
        static var title = "Channel Title"
        static var message = "Enter your preffered channel name"
    }
    
    struct AlertActions {
        static var create = "Create"
        static var close = "Close"
        static var cancel = "Cancel"
    }
    
    struct Alerts {
        static var titleError = "Error!"
    }
    
    struct Validations {
        static var emptyChannelName = "Channel name cannot be left blank."
    }
    
    struct Messages {
        static var errorCreatingChannel = "Error creating channel."
        static var successCreatingChannel = "Channel created successfully."
        static var emptyUsername = "Username cannot be left bank."
    }
}
