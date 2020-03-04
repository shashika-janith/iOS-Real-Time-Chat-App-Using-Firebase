//
//  Date.swift
//  ChatApp
//
//  Created by Sashika on 3/3/20.
//  Copyright © 2020 Shashika. All rights reserved.
//

import Foundation

extension Date {
    
    func getStringRepresentationOfDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strRepresentation = df.string(from: self)
        
        return strRepresentation

    }
    
    func getDateRepresentationOfString(dateStr: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateRepresentation = df.date(from: dateStr)
        
        return dateRepresentation
    }
    
}
