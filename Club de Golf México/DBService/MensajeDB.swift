//
//  MensajeDB.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SQLite

class MensajeDB {
    
    var dbConnection: Connection!
    
    let name = "mensaje"
    
    let table = Table("mensaje")

    let schema = "CREATE TABLE mensaje (mensaje_id INTEGER PRIMARY KEY AUTOINCREMENT, mensaje_web_id INTEGER, mensaje_area_eid INTEGER, mensaje_tipo_eid INTEGER, mensaje_fecha_enviado TEXT, mensaje_titulo TEXT, mensaje_contenido TEXT, mensaje_link TEXT, mensaje_icon TEXT, mensaje_image TEXT, mensaje_visto INTEGER, mensaje_recibido INTEGER, mensaje_fecha_visto TEXT, mensaje_fecha_limite TEXT, delete_flag BOOL)"
    
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
    
    func select(withID message_id: Int) -> MensajeType? {
        
        do {
            let id = Expression<Int>("mensaje_id")
            
            let query = self.table.filter(id == message_id)
            
            let list: [MensajeType] = try self.dbConnection.prepare(query).map { row in
                return try row.decode()
            }
            
            if list.count > 0 {
                return list[0]
            } else {
                return nil
            }
            

        } catch let error {
            print(error)
            return nil
        }
        
    }
    func insert(_ mensaje: MensajeType) -> Int {
        
        do {
            
            var lastID = 0
            
            try self.dbConnection.transaction {
                
                lastID  = try Int(self.dbConnection.run(self.table.insert(mensaje)))
                
            }
            return lastID
            
        } catch let error {
            
            print(error)
            return 0
        }
    }
    
    func update(_ message: MensajeType) -> Bool {
        
        do {
            
            try self.dbConnection.transaction {
                
                let id = Expression<Int>("mensaje_id")
                
                try self.dbConnection.run(self.table.filter(id == message.mensaje_id!).update(message))
            }
            
            return true
            
        } catch let error {
            
            print(error)
            return false
        }
    }
    
    func delete(_ message: MensajeType) -> Bool {
        
        do {
            
            try self.dbConnection.transaction {
                
                let id = Expression<Int>("mensaje_id")
                
                try self.dbConnection.run(self.table.filter(id == message.mensaje_id!).delete())
            }
            
            return true
            
        } catch let error {
            
            print(error)
            return false
        }
    }

    
    func unreadMessages(withAreas areas: [Int]? ) -> [MensajeType] {
        do {
            
            let area_eid = Expression<Int>("mensaje_area_eid")
            
//            let mensaje_fecha_limite = Expression<String>("mensaje_fecha_limite")
            let del_flag = Expression<Bool>("delete_flag")
            
            var filterQuery: Expression<Bool>
            
            if areas != nil {
                
                filterQuery = del_flag == false && areas!.contains(area_eid) // && mensaje_fecha_limite == ""


            } else {
                
                filterQuery = del_flag == false
            }
            
            let list: [MensajeType] = try self.dbConnection.prepare(self.table.filter(filterQuery)).map { row in
                return try row.decode()
            }
            
            return list

            
        } catch let error {
            print(error)
            return []
        }
    }
    
    func unreadCount(withAreas areas: [Int]?) -> Int {
        
        do {
            
            let area_eid = Expression<Int>("mensaje_area_eid")
            
            let mensaje_visto = Expression<Int>("mensaje_visto")
            
//            let mensaje_fecha_limite = Expression<String>("mensaje_fecha_limite")

            var filterQuery: Expression<Bool>
            
            if areas != nil {
                filterQuery = mensaje_visto == 0 && areas!.contains(area_eid) //&& mensaje_fecha_limite == ""
            } else {
                filterQuery = mensaje_visto == 0 // && mensaje_fecha_limite == ""
            }
            
            return try self.dbConnection.scalar(self.table.filter(filterQuery).count)
            
        } catch let error {
            print(error)
            return 0
        }

    }
    
    func eventList() -> [MensajeType] {
        
        do {
            
            let mensaje_fecha_limite = Expression<String>("mensaje_fecha_limite")
            
            var filterQuery: Expression<Bool>
            
            
            filterQuery = mensaje_fecha_limite != ""
                
                
            let list: [MensajeType] = try self.dbConnection.prepare(self.table.filter(filterQuery)).map { row in
                return try row.decode()
            }
            
            return list.filter{
                    $0.mensaje_fecha_limite.dateFromISO8601! > Date()
                }.sorted { $0.mensaje_fecha_limite < $1.mensaje_fecha_limite}
            
        } catch let error {
            print(error)
            return []
        }
    }
    
    func all() -> [MensajeType] {
        do {
            let list: [MensajeType] = try self.dbConnection.prepare(self.table).map { row in
                return try row.decode()
            }
            return list
        } catch let error {
            print(error)
            return []
        }
    }
    

    
}
