//
//  FloatExtensions.swift
//  Club de Golf México
//
//  Created by admin on 2/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
extension Float {
    var currencyString: String {
        return  Formatter.currency.string(for: self) ?? ""
    }
}
