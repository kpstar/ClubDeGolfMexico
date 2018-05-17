//
//  ArchivosDB.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SQLite

class ArchivosDB {
    
    var dbConnection: Connection!
    
    let name = "archivos"
    
    let table = Table("archivos")

    let schema = "CREATE TABLE archivos (archivo_mensaje_id INTEGER PRIMARY KEY, archivo_borrado INTEGER, archivo_vencido INTEGER)"
    
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
    
    
    func insert(_ archivo: ArchivosType) -> Bool {
        
        do {
            try self.dbConnection.transaction {
                try self.dbConnection.run(self.table.insert(archivo))

            }
            return true
            
        } catch let error {
            
            print(error)
            return false
        }
    }

}
