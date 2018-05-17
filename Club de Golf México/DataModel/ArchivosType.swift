//
//  ArchivosType.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct ArchivosType: Encodable, Decodable {
    
    var archivo_mensaje_id: Int
    
    var archivo_borrado: Int
    
    var archivo_vencido: Int
    
}
