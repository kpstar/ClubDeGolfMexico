//
//  PagosDB.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SQLite

class PagosDB {
    
    var dbConnection: Connection!
    
    let name = "pagos"
    
    let table = Table("pagos")
    
    let schema = "CREATE TABLE pagos (pago_id INTEGER PRIMARY KEY, pago_card TEXT, pago_referencia TEXT, pago_fecha TEXT, pago_amount TEXT, pago_importe REAL, pago_codigo_aut TEXT, pago_kerror TEXT, pago_origen_id INTEGER, pago_confirmado TEXT, pago_comentarios TEXT, pago_status TEXT, pago_recibo TEXT, pago_factura TEXT)"
    
    init(connection: Connection) {
        self.dbConnection = connection
        self.create()
    }
    
    func create() {
        do {
            try self.dbConnection.transaction {
                try self.dbConnection.execute(self.schema)
            }
            print("Created \(name) successfully")
        } catch let error {
            print(error)
        }
    }
    
    func drop() {
        do {
            try self.dbConnection.transaction {
                try self.dbConnection.execute("DROP TABLE IF EXISTS \(name)");
            }
        } catch let error {
            print(error)
        }
    }
    
    func insert(_ pagos: PagosType) -> Bool {
        
        do {
            try self.dbConnection.transaction {
                
                try self.dbConnection.run(self.table.insert(pagos))
                
            }
            return true
            
        } catch let error {
            
            print(error)
            return false
        }
    }
    
    func update(_ pagos: PagosType) -> Bool {
        
        do {
            
            try self.dbConnection.transaction {
                
                let id = Expression<Int>("pagos_id")
                
                try self.dbConnection.run(self.table.filter(id == pagos.pago_id).update(pagos))
            }
            
            return true
            
        } catch let error {
            
            print(error)
            return false
        }
    }

    func all() -> [PagosType] {
        do {
            let list: [PagosType] = try self.dbConnection.prepare(self.table).map { row in
                return try row.decode()
            }
            return list.sorted { $0.pago_fecha > $1.pago_fecha}
        } catch let error {
            print(error)
            return []
        }
    }

    func select(withID pagos_id: Int) -> PagosType? {
        
        do {
            let id = Expression<Int>("pagos_id")

            let query = self.table.filter(id == pagos_id)
            if let row = try self.dbConnection.pluck(query) {
                return try row.decode()
            } else {
                return nil
            }

        } catch let error {
            print(error)
            return nil
        }
        
    }
    
}
