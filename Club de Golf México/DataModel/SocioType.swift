//
//  SocioType.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
struct SocioType: Encodable, Decodable {
    var socio_id = 0
    var socio_nombre = ""
    var socio_nombre_app = "'"
    var socio_accion_num = ""
    var socio_nacimiento = ""
    var socio_correo = ""
    var socio_facebook = ""
    var socio_imagen = ""
}
