//
//  User.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/18.
//

import Foundation

struct User: Equatable, Identifiable {
    let id = UUID()
    var name: String = ""
    var roll: Roll = .none
}
enum Roll: String {
    case none = "시민"
    case liar = "라이어"
    case spy = "스파이"
}


