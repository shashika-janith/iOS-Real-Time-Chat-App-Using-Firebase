//
//  Channel.swift
//  ChatApp
//
//  Created by Sashika on 2/28/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation
import Firebase

class Channel {
    var id: String?
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String else {
            return nil
        }
        
        self.name = name
        self.id = document.documentID
    }
}

extension Channel {
    var representation: [String : Any] {
        var rep = ["name": name]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
}

extension Channel: Comparable {
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
    
}
