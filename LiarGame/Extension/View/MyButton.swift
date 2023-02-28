//
//  MyButton.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/18.
//

import SwiftUI

extension View {
    func fitButton(color: Color, vertical: CGFloat, horizontal: CGFloat) -> some View {
        modifier(FitButton(color: color, vertical: vertical, horizontal: horizontal))
    }
    
    func wideButton(color: Color) -> some View {
        modifier(WideButton(color: color))
    }
}

struct FitButton: ViewModifier {
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


struct WideButton: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity)
            .font(.largeTitle.bold())
            .foregroundColor(.white)
            .padding()
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
    }
}

