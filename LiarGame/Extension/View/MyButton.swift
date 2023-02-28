//
//  MyButton.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/18.
//

import SwiftUI

extension View {
    func myButtonStyle(color: Color, vertical: CGFloat, horizontal: CGFloat) -> some View {
        modifier(MyButton(color: color, vertical: vertical, horizontal: horizontal))
    }
}

struct MyButton: ViewModifier {
    let color: Color
    let vertical: CGFloat
    let horizontal: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(.vertical,vertical)
            .padding(.horizontal, horizontal)
            .foregroundColor(.white)
            .background(color)
            .font(.title2)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
