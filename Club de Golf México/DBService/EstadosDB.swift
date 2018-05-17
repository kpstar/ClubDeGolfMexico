//
//  EstadosDB.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SQLite

class EstadosDB {
    
    var dbConnection: Connection!
    
    let name = "estados"
    
    let table = Table("estados")
    
    let schema = "CREATE TABLE estados (estado_mensaje_id INTEGER PRIMARY KEY, estado_fecha TEXT, estado_periodo TEXT, estado_anio INTEGER, estado_mes INTEGER, estado_importe REAL, estado_archivo TEXT)"
    
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
    
    func insert(_ estado: EstadosType) -> Bool {
        
        do {
            try self.dbConnection.transaction {
                try self.dbConnection.run(self.table.insert(estado))
                
            }
            return true
            
        } catch let error {
            
            print(error)
            return false
        }
    }
    
    func all() -> [EstadosType] {
        do {
            let list: [EstadosType] = try self.dbConnection.prepare(self.table).map { row in
                return try row.decode()
            }
            return list.sorted { $0.estado_fecha > $1.estado_fecha}
        } catch let error {
            print(error)
            return []
        }
    }


    
    
}
