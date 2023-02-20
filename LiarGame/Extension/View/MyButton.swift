//
//  MyButton.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/18.
//

import SwiftUI

extension View {
    func myButtonStyle(color: Color) -> some View {
        modifier(MyButton(color: color))
    }
}

struct MyButton: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content
            .padding(.vertical,10)
            .padding(.horizontal, 20)
            .foregroundColor(.white)
            .background(color)
            .font(.title2)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
