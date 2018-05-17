//
//  DateExtension.swift
//  Housing Price Analyzer
//
//  Created by admin on 2/2/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

extension Date {
    
    var hourString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    var dayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    var longDayString: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    var shortDayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    var shortDateTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy hh:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }


    
    
    var yearMonthPath: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: -6)
        return dateFormatter.string(from: self)
    }
    
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }     
}
