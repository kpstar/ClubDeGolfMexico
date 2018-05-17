//
//  GaleriasDB.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SQLite

class GaleriasDB {
    
    var dbConnection: Connection!
    
    let name = "galerias"
    
    let table = Table("galerias")

    
    let schema = "CREATE TABLE galerias (galeria_id INTEGER PRIMARY KEY, galeria_mensaje_id INTEGER, galeria_titulo TEXT, galeria_contenido TEXT, galeria_resena TEXT, galeria_image TEXT, galeria_path TEXT, galeria_realizado TEXT, timeStamp TEXT)"
    
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
    
    func insert(_ gallery: GaleriasType) -> Bool {
        
        do {
            try self.dbConnection.transaction {
                try self.dbConnection.run(self.table.insert(gallery))
                
            }
            return true
            
        } catch let error {
            
            print(error)
            return false
        }
    }
    
    func all() -> [GaleriasType] {
        do {
            let list: [GaleriasType] = try self.dbConnection.prepare(self.table).map { row in
                return try row.decode()
            }
            return list.sorted{ $0.timeStamp > $1.timeStamp}
        } catch let error {
            print(error)
            return []
        }
    }

    
}
