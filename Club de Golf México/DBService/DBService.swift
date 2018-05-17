//
//  DBService.swift
//  Club de Golf México
//
//  Created by admin on 2/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SQLite

class DBService {
    
    static var shared = DBService()
    
    var dbConnection: Connection!
    
    var socioDB: SocioDB!
    var mensajeDB: MensajeDB!
    var tarjetasDB: TarjetasDB!
    var archivosDB: ArchivosDB!
    var estadosDB: EstadosDB!
    var pagosDB: PagosDB!
    var galeriasDB: GaleriasDB!
    var reservasDB: ReservasDB!
    
    init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            
            self.dbConnection = try Connection("\(path)/websCDGM.sqlite3")
            
            self.socioDB = SocioDB(connection: self.dbConnection)
            self.mensajeDB = MensajeDB(connection: self.dbConnection)
            self.tarjetasDB = TarjetasDB(connection: self.dbConnection)
            self.archivosDB = ArchivosDB(connection: self.dbConnection)
            self.estadosDB = EstadosDB(connection: self.dbConnection)
            self.pagosDB = PagosDB(connection: self.dbConnection)
            self.galeriasDB = GaleriasDB(connection: self.dbConnection)
            self.reservasDB = ReservasDB(connection: self.dbConnection)
            
        } catch {
            print("Create sqlite error!")
        }

    }
    
    func unReadMessage(withAreas areas: [Int]?) -> [MensajeType] {
        
        let list = self.mensajeDB.unreadMessages(withAreas: areas)
        
        return list.sorted { $0.mensaje_fecha_enviado > $1.mensaje_fecha_enviado}

    }
    
    
    
    
    
}
