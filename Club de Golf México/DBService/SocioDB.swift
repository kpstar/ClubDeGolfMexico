//
//  SocioDB.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SQLite

class SocioDB {
    
    var dbConnection: Connection!
    
    let name = "socio"
    
    let table = Table("socio")
    
    let schema = " CREATE TABLE socio (socio_id INTEGER PRIMARY KEY, socio_nombre TEXT, socio_nombre_app TEXT, socio_accion_num TEXT, socio_nacimiento TEXT, socio_correo TEXT, socio_facebook TEXT, socio_imagen TEXT)"

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
    
    func truncate() {
        self.drop()
        self.create()
    }
    
    func insert(_ socio: SocioType) -> Bool {
        
        do {
            try self.dbConnection.transaction {
                try self.dbConnection.run(self.table.insert(socio))
            }
            return true
            
        } catch let error {
            
            print(error)
            return false
        }
    }
    
    func all() {
        do {
            let list: [SocioType] = try self.dbConnection.prepare(self.table).map { row in
                return try row.decode()
            }
            print(list)
        } catch let error {
            print(error)
        }
    }
    
    
    
}
