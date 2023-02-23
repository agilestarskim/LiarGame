//
//  User.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/18.
//

import SwiftUI

struct User: Equatable, Identifiable {
    let id = UUID()
    var name: String = ""
    var roll: Roll = .none
}

enum Roll: String {
    case none = "Citizen"
    case liar = "Liar"
    case spy = "Spy"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}


