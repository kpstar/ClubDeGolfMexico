//
//  GaleriasType.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct GaleriasType: Encodable, Decodable {
    
    var galeria_id: Int
    
    var galeria_mensaje_id: Int
    
    var galeria_titulo: String
    
    var galeria_contenido: String
    
    var galeria_resena: String
    
    var galeria_image: String
    
    var galeria_path: String
    
    var galeria_realizado: String
    
    var timeStamp: String
    
}
