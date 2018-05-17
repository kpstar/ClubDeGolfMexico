//
//  ReservasType.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct ReservasType: Encodable, Decodable {
    
    var reserva_id: Int?
    
    var reserva_web_id: Int
    
    var reserva_area_eid: Int
    
    var reserva_fecha: String
    
    var reserva_hoyo_mesa: Int
    
    var reserva_personas: Int
    
}
