//
//  EstadosType.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct EstadosType: Encodable, Decodable {
    
    var estado_mensaje_id: Int
    
    var estado_fecha: String
    
    var estado_periodo: String
    
    var estado_anio: Int
    
    var estado_mes: Int
    
    var estado_importe: Float
    
    var estado_archivo: String
    
}
