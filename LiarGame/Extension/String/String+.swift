//
//  String+.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/23.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
