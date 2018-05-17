//
//  MensajeType.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct MensajeType: Encodable, Decodable {
    
    var mensaje_id: Int?
    
    var mensaje_web_id: Int
    
    var mensaje_area_eid: Int
    
    var mensaje_tipo_eid: Int
    
    var mensaje_fecha_enviado: String
    
    var mensaje_titulo: String
    
    var mensaje_contenido: String
    
    var mensaje_link: String
    
    var mensaje_icon: String
    
    var mensaje_image: String
    
    var mensaje_visto: Int
    
    var mensaje_recibido: Int
    
    var mensaje_fecha_visto: String
    
    var mensaje_fecha_limite: String
    
    var delete_flag : Bool
    
}
