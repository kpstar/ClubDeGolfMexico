//
//  TarjetasDB.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SQLite

class TarjetasDB {
    
    var dbConnection: Connection!

    let name = "tarjetas"
    
    let schema = "CREATE TABLE tarjetas (tarjeta_pos INTEGER, tarjeta_token TEXT, tarjeta_brand TEXT, tarjeta_last4 TEXT)"

    
    init(connection: Connection) {
        self.dbConnection = connection
    }
    
    func create() {
        do {
            try self.dbConnection.execute(self.schema)
        } catch {
            
        }
    }
    
    func drop() {
        do {
            try self.dbConnection.execute("DROP TABLE IF EXISTS \(name)");
        } catch {
            
        }
    }
}
