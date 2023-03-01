//
//  HideKeyboard.swift
//  LiarGame
//
//  Created by 김민성 on 2023/03/01.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
