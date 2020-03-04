//
//  Chat.swift
//  ChatApp
//
//  Created by Sashika on 2/28/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation
import Firebase

class Message {
    
    var id: String?
    let created: Date
    let senderID: String
    let senderName: String
    var content: String?
    var imageURL: String?
    
    init(message: String, senderID: String, senderName: String) {
        self.senderID = senderID
        self.senderName = senderName
        self.content = message
        self.created = Date()
    }
    
    init(imageURL: String, senderID: String, senderName: String) {
        self.senderID = senderID
        self.senderName = senderName
        self.imageURL = imageURL
        self.created = Date()
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard
            let senderID = data["senderID"] as? String,
            let senderName = data["senderName"] as? String,
            let created = data["createdOn"] as? String else {
            return nil
        }
        
        let content = data["content"] as? String
        let url = data["url"] as? String
        
        self.id = document.documentID
        self.senderID = senderID
        self.senderName = senderName
        self.content = content
        self.created = Date().getDateRepresentationOfString(dateStr: created)!
        self.imageURL = url
    }
    
}

extension Message {
    
    var representation : [String : Any] {
        var rep: [String : Any] = [:]
        rep["senderID"] = senderID
        rep["senderName"] = senderName
        rep["createdOn"] = created.getStringRepresentationOfDate()
        
        if let id = id {
            rep["id"] = id
        }
        
        if !(imageURL?.isEmpty ?? true) {
            rep["url"] = imageURL
        } else {
            rep["content"] = content
        }
        
        return rep
    }
    
}

extension Message: Comparable {
    static func < (lhs: Message, rhs: Message) -> Bool {
        let order = lhs.created.compare(rhs.created)
        
        switch order {
        case .orderedAscending:
            return true
        case .orderedDescending:
            return false
        case .orderedSame:
            return true
        }
        
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
}
