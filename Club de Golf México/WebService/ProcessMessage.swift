//
//  ProcessMessage.swift
//  Club de Golf México
//
//  Created by admin on 2/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import AudioToolbox
import SwiftyJSON

let notificationNameReceiveNewMessage = Notification.Name("NotificationReceiveNewMessage")
//
//protocol ProcessMessageDelegate {
//
//}

class ProcessMessage {
    
    static let shared = ProcessMessage()

    func process(_ newMessage: JSON) {
        
        let messageID = self.processMessage(newMessage)
        let code = newMessage["code"].intValue
        
        if messageID == 0 {
            return
        }
        
        let currentDateandTime = Date().iso8601
        let user_id = UserDefaults.standard.string(forKey: kUserID) ?? "0"
        let params = ["0", String(messageID), newMessage["id"].stringValue, user_id, currentDateandTime]
        WebService.shared.sendRequest(codigo: 200, data: params) { (isSuccess, errorMessage, resultData) in
            if !isSuccess {
                return
            }
            
            if Int((resultData?[1] ?? "0")) != 1 {
                return
            }
            
            if Int((resultData?[0] ?? "0")) != 200 {
                return
            }
            
            let mensaje_id = Int(resultData?[3] ?? "0") ?? 0
            
            guard var mensaje = DBService.shared.mensajeDB.select(withID: mensaje_id) else {
                return
            }
            mensaje.mensaje_recibido = 1
            
            _ = DBService.shared.mensajeDB.update(mensaje)
            
            if code == 1959 {
                UIApplication.shared.applicationIconBadgeNumber = 0
                self.processResetPhone()
            }
            
        }
        
        switch code {
        case 0 : //Mensaje
            // NOTHING EXTRA TO DO
            break
        case 10: // Estado de cuenta
            self.processEstado(messageID: messageID, newMessage: newMessage)
            break
        case 20, 25: // Pago, Confirmación
            self.processPago(messageID: messageID, newMessage: newMessage)
            break
        case 30: //  Restaurante
            break
        case 35: // Reservacion Restaurante
            self.processReserveRestraunt(messageID: messageID, newMessage: newMessage)
            break
        case 45: // Reservacion Golf
            self.processReserveGolf(messageID: messageID, newMessage: newMessage)
            break;
        case 47: // Cancela Golf
            let jugadorId = newMessage["jugadorId"].intValue
            _ = DBService.shared.reservasDB.delete(withWebID: jugadorId)
            break
        case 50: // Galeria
            self.processGallery(messageID: messageID, newMessage: newMessage)
            break
        case 177:
            UserDefaults.standard.set(true, forKey: kUpdateCards)
            break
        case 1100:
            self.processGolfLink(messageID: messageID, newMessage: newMessage)
            break
        case 1200:
            UserDefaults.standard.set(newMessage["message"].stringValue, forKey: kFloatingCuentas)
            break
        default:
            break
        }
        
        //let isBackground = newMessage["isBackground"].intValue

        NotificationCenter.default.post(name: notificationNameReceiveNewMessage, object: nil)
        
//        if UserDefaults.standard.bool(forKey: kNotification) && isBackground != 1 {
//
//            var toneName = "golf_swing.mp3"
//            let tone = ToneOptions(rawValue: UserDefaults.standard.string(forKey: kNotificationTone)!)!
//            switch tone {
//
//            case .swingDrive:
//                toneName = "golf_swing.caf"
//
//            case .swingMadera:
//                toneName = "golf_wood.caf"
//
//            case .fore:
//                toneName = "golf_fore.caf"
//
//            case .golf:
//                toneName = "golf_girl.caf"
//
//            case .bolaGolf:
//                toneName = "golf_bounce.caf"
//            }
//
//            SoundManager.sharedInstance.playWith(file: toneName)
//
//            if UserDefaults.standard.bool(forKey: kNotificationVibration) {
//                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//            }
//
//        }
        
        

    }
    
    func processResetPhone() {
        DBService.shared.archivosDB.drop()
        DBService.shared.estadosDB.drop()
        DBService.shared.galeriasDB.drop()
        DBService.shared.mensajeDB.drop()
        DBService.shared.pagosDB.drop()
        DBService.shared.reservasDB.drop()
        DBService.shared.socioDB.drop()
        DBService.shared.tarjetasDB.drop()
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        UIApplication.shared.applicationIconBadgeNumber = 0
        exit(0)
    }
    
    func processMessage(_ newMessage: JSON) -> Int {
        
        let code = newMessage["code"].intValue
        
        switch code {
        case 1100:
            return 1
        case 1200:
            return 1
        default:
            break
        }
        
        let webId = newMessage["id"].intValue
        let title = newMessage["title"].stringValue
        let message = newMessage["message"].stringValue
        var timestamp = newMessage["timeStamp"].stringValue
        let area = newMessage["area"].intValue
        let tipo = newMessage["tipo"].intValue
        let icon = newMessage["icon"].stringValue
        let image = newMessage["image"].stringValue
        let link = newMessage["link"].stringValue
        var limit = newMessage["limite"].stringValue
        
        if timestamp != "" {
           timestamp += " -0500"
        }
        
        if limit != "" {
            limit += " -0500"
        }
        
        if limit.dateFromISO8601 == nil {
            limit = ""
        }
        
        let newMesanje = MensajeType(mensaje_id: nil, mensaje_web_id: webId, mensaje_area_eid: area, mensaje_tipo_eid: tipo, mensaje_fecha_enviado: timestamp, mensaje_titulo: title, mensaje_contenido: message, mensaje_link: link, mensaje_icon: icon, mensaje_image: image, mensaje_visto: 0, mensaje_recibido: 0, mensaje_fecha_visto: "", mensaje_fecha_limite: limit, delete_flag: false)
        
        return DBService.shared.mensajeDB.insert(newMesanje)
        
    }
    
    func  processGolfLink(messageID: Int, newMessage: JSON) {
        print(newMessage["message"].stringValue)
        UserDefaults.standard.set(newMessage["message"].stringValue, forKey: kFloatingGolflink)
    }
    
    func  processEstado(messageID: Int, newMessage: JSON) {
        
        let archivo = ArchivosType(archivo_mensaje_id: messageID, archivo_borrado: 0, archivo_vencido: 0)
        _ = DBService.shared.archivosDB.insert(archivo)
        
        var timestamp = newMessage["timeStamp"].stringValue
        let periodo = newMessage["periodo"].stringValue
        let image = newMessage["image"].stringValue
        let anio = newMessage["anio"].intValue
        let mes = newMessage["mes"].intValue
        let importe = newMessage["importe"].floatValue
        
        if timestamp != "" {
            timestamp += " -0500"
        }

        let estado = EstadosType(estado_mensaje_id: messageID, estado_fecha: timestamp, estado_periodo: periodo, estado_anio: anio, estado_mes: mes, estado_importe: importe, estado_archivo: image)
        
        _ = DBService.shared.estadosDB.insert(estado)
        
        
    }
    
    func processPago(messageID: Int, newMessage: JSON) {

        let pagoId = newMessage["pagoId"].intValue
        let card = newMessage["card"].stringValue
        let referencia = newMessage["referencia"].stringValue
        var fecha = newMessage["fecha"].stringValue
        let amount = newMessage["amount"].stringValue
        let importe = newMessage["importe"].floatValue
        let codigoAut = newMessage["codigoAut"].stringValue

        let kError = newMessage["kError"].stringValue
        let origenId = newMessage["origenId"].intValue
        var confirmado = newMessage["confirmado"].stringValue
        let comentarios = newMessage["comentarios"].stringValue
        let status = newMessage["status"].stringValue
        let recibo = newMessage["recibo"].stringValue
        let factura = newMessage["factura"].stringValue
        
        if fecha != "" {
            fecha += " -0500"
        }
        
        if confirmado != "" {
            confirmado += " -0500"
        }
        if confirmado.dateFromISO8601 == nil {
            confirmado = ""
        }


        let pagos = PagosType(pago_id: pagoId, pago_card: card, pago_referencia: referencia, pago_fecha: fecha, pago_amount: amount, pago_importe: importe, pago_codigo_aut: codigoAut, pago_kerror: kError, pago_origen_id: origenId, pago_confirmado: confirmado, pago_comentarios: comentarios, pago_status: status, pago_recibo: recibo, pago_factura: factura)
        
        if DBService.shared.pagosDB.select(withID: pagoId) == nil {
          _ = DBService.shared.pagosDB.insert(pagos)
        } else {
          _ = DBService.shared.pagosDB.update(pagos)
        }
        
        
    }
    
    
    func processReserveRestraunt(messageID: Int, newMessage: JSON) {

        let archivo = ArchivosType(archivo_mensaje_id: messageID, archivo_borrado: 0, archivo_vencido: 0)
        _ = DBService.shared.archivosDB.insert(archivo)

        let reservacionId = newMessage["reservacionId"].intValue
        let area = newMessage["area"].intValue
        var limite = newMessage["limite"].stringValue
        let mesa = newMessage["mesa"].intValue
        let personas = newMessage["personas"].intValue
        
        if limite != "" {
            limite += " -0500"
        }
        
        if limite.dateFromISO8601 == nil {
            limite = ""
        }

        let reserveRestraunt = ReservasType(reserva_id: nil, reserva_web_id: reservacionId, reserva_area_eid: area, reserva_fecha: limite, reserva_hoyo_mesa: mesa, reserva_personas: personas)
        
        _ = DBService.shared.reservasDB.insert(reserveRestraunt)

    }
    
    
    func processReserveGolf(messageID: Int, newMessage: JSON) {
        
        let jugadorId = newMessage["jugadorId"].intValue
        let area = newMessage["area"].intValue
        var limite = newMessage["limite"].stringValue
        let hoyo = newMessage["hoyo"].intValue
        
        if limite != "" {
            limite += " -0500"
        }
        
        if limite.dateFromISO8601 == nil {
            limite = ""
        }
        let reserveGolf = ReservasType(reserva_id: nil, reserva_web_id: jugadorId, reserva_area_eid: area, reserva_fecha: limite, reserva_hoyo_mesa: hoyo, reserva_personas: 0)
        
        _ = DBService.shared.reservasDB.insert(reserveGolf)
        
    }
    
    func processGallery(messageID: Int, newMessage: JSON) {

        let archivo = ArchivosType(archivo_mensaje_id: messageID, archivo_borrado: 0, archivo_vencido: 0)
        _ = DBService.shared.archivosDB.insert(archivo)
        
        let galeriaId = newMessage["galeriaId"].intValue
        let mensajeId = newMessage["mensajeId"].intValue
        let title = newMessage["title"].stringValue
        let message = newMessage["message"].stringValue
        let resena = newMessage["resena"].stringValue
        let image = newMessage["image"].stringValue
        let path = newMessage["path"].stringValue
        
        var realizado = newMessage["realizado"].stringValue
        
        var timestamp = newMessage["timeStamp"].stringValue
        
        if realizado != "" {
            realizado += " -0500"
        }
        
        if timestamp != "" {
            timestamp += " -0600"
        }
        
        let gallery = GaleriasType(galeria_id: galeriaId, galeria_mensaje_id: mensajeId, galeria_titulo: title, galeria_contenido: message, galeria_resena: resena, galeria_image: image, galeria_path: path, galeria_realizado: realizado, timeStamp: timestamp)
                
        _ = DBService.shared.galeriasDB.insert(gallery)

    }
    
}
