//
//  StringExtension.swift
//  Club de Golf México
//
//  Created by admin on 2/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

extension String
{
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        let replacedString =  self.replacingOccurrences(of: "+", with: " ")
        return replacedString.removingPercentEncoding
    }
    
    func padString() -> String {
        
        let paddingChar:Character = Character(UnicodeScalar(32))
        
        let size = 16
        
        let x = self.count % size
        
        let padLength = size - x
        
        var padString = self
        
        for _ in  0..<padLength-1 {
            padString.append(paddingChar)
        }
        
        return padString
        
    }
    
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
    
    var dateFromDayString: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)
    }
    
}
