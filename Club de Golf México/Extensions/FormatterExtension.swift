//
//  FormatterExtension.swift
//  Club de Golf México
//
//  Created by admin on 2/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: -6)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzzz"
        return formatter
    }()
    
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencySymbol = ""
        formatter.groupingSeparator = ","
        formatter.numberStyle = .currency
        return formatter
    }()

}
