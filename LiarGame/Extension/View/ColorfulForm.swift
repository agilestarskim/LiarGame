//
//  ColorfulForm.swift
//  LiarGame
//
//  Created by 김민성 on 2023/03/14.
//

import SwiftUI

extension Form {
    func colorfulForm() -> some View {
        modifier(ColorfulForm())
    }
}

struct ColorfulForm: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
                .background(BackgroundView2())
        } else {
            content
        }
    }
}

struct BackgroundView2: View {
    var body: some View {
        ZStack {
            RadialGradient(colors: [.orange, .yellow], center: .center, startRadius: 0, endRadius: 270)
                .blur(radius: 200)
            Color.black
                .opacity(0.1)
                .ignoresSafeArea()
        }
        
            .ignoresSafeArea()
    }
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .tertiarySystemBackground)
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                let size = proxy.size
                
                Color.black
                    .opacity(0.1)
                    .ignoresSafeArea()
                
                Circle()
                    .fill(Color("Circle1"))
                    .padding(50)
                    .blur(radius: 120)
                    .offset(x: -size.width / 1.8, y: -size.height / 5)
                
                Circle()
                    .fill(Color("Circle2"))
                    .padding(50)
                    .blur(radius: 150)
                    .offset(x: size.width / 1.8, y: -size.height / 5)
                
                Circle()
                    .fill(Color("Circle2"))
                    .padding(50)
                    .blur(radius: 90)
                    .offset(x: size.width / 1.8, y: size.height / 2)
                
                Circle()
                    .fill(Color("Circle1"))
                    .padding(100)
                    .blur(radius: 110)
                    .offset(x: size.width / 1.8, y: size.height / 2)
                
                Circle()
                    .fill(Color("Circle1"))
                    .padding(100)
                    .blur(radius: 110)
                    .offset(x: -size.width / 1.8, y: size.height / 2)
            }
        }
    }
}

struct Glass: View {
    var body: some View {
        Rectangle()
            .fill(.white)
            .opacity(0.7)
    }
}
