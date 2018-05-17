//
//  TarjetasType.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct TarjetasType: Encodable, Decodable {
    
    var tarjeta_pos: Int
    
    var tarjeta_token: String
    
    var tarjeta_brand: String
    
    var tarjeta_last4: String
    
}
