//
//  ReservasDB.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

import SQLite

class ReservasDB {
    
    var dbConnection: Connection!
    
    let name = "reservas"
    
    let table = Table("reservas")
    
    let schema = "CREATE TABLE reservas (reserva_id INTEGER PRIMARY KEY AUTOINCREMENT, reserva_web_id INTEGER, reserva_area_eid INTEGER, reserva_fecha TEXT, reserva_hoyo_mesa INTEGER, reserva_personas INTEGER)"
    
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
    
    func insert(_ reserve: ReservasType) -> Bool {
        
        do {
            try self.dbConnection.transaction {
                try self.dbConnection.run(self.table.insert(reserve))
                
            }
            return true
            
        } catch let error {
            
            print(error)
            return false
        }
    }
    
    func delete(withWebID web_id:Int) -> Bool {
        
        do {
            try self.dbConnection.transaction {
                
                let reserva_web_id = Expression<Int>("reserva_web_id")

                try self.dbConnection.run(self.table.filter(reserva_web_id == web_id).delete())
                
            }
            return true
            
        } catch let error {
            
            print(error)
            return false
        }

    }
}
