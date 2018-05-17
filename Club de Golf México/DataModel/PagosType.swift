//
//  PagosType.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct PagosType: Encodable, Decodable {
    
    var pago_id: Int
    
    var pago_card: String
    
    var pago_referencia: String
    
    var pago_fecha: String
    
    var pago_amount: String
    
    var pago_importe: Float
    
    var pago_codigo_aut: String
    
    var pago_kerror: String
    
    var pago_origen_id: Int
    
    var pago_confirmado: String
    
    var pago_comentarios: String
    
    var pago_status: String
    
    var pago_recibo: String
    
    var pago_factura: String
    
}
