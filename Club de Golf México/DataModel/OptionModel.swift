//
//  OptionModel.swift
//  Club de Golf México
//
//  Created by admin on 2/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

enum  AddFriendsMessagesOptions: String {
    
    case always = "Always"
    case whenPossible = "When possible"
    case never = "Never"
    
    static let all = [always, whenPossible, never]
    static let allString = [always.rawValue, whenPossible.rawValue, never.rawValue]
}

enum ToneOptions: String {
    
    case swingDrive = "Swing de Drive"
    case swingMadera = "Swiing con Madera"
    case fore = "FORE"
    case golf = "GOLF"
    case bolaGolf = "Bola de golf"
    
    static let all = [swingDrive, swingMadera, fore, golf, bolaGolf]
    static let allString = [swingDrive.rawValue, swingMadera.rawValue, fore.rawValue, golf.rawValue, bolaGolf.rawValue]

}

enum RecordActivityOptions: String {
    
    case fiveMin = "5 minutos antes"
    case tenMin = "10 minutos antes"
    case fifteenMin = "15 minutos antes"
    case halfHour = "30 minutos antes"
    case oneHour = "1 horas antes"
    case twoHour = "2 horas antes"
    case noRecord = "No recordar nunca"

    static let all = [fiveMin, tenMin, fifteenMin, halfHour, oneHour, twoHour, noRecord]
    static let allString = [fiveMin.rawValue, tenMin.rawValue, fifteenMin.rawValue, halfHour.rawValue, oneHour.rawValue, twoHour.rawValue, noRecord.rawValue]

}
