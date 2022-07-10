//
//  GameView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/01.
//

import SwiftUI

struct GameView: View {
    let mode: Mode
    let members: Int
    let subject: String
    let time: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let data: Data
    @State private var list: [String]
    @State private var remainingTime: Int
    @State private var showingCard = false
    @State private var index = 0
    @State private var isGameStart = false
    @State private var isGameEnd = false
    
    @Environment(\.dismiss) var dismiss
    @Binding var rootIsActive : Bool
    init(mode: Mode, members: Int, subject: String, time: Int, rootIsActive: Binding<Bool>){
        self.mode = mode
        self.members = members
        self.subject = subject
        self.time = time
        self.data = Data(subject: subject, members: members, mode: mode)
        _remainingTime = State(wrappedValue: time * 60)
        _list = State(wrappedValue: data.list)
        _rootIsActive = rootIsActive
    }
    
    var body: some View {
        VStack{
            Text("\(subject)")
                .font(.title.bold())
                .padding()
            Text("\(mode.rawValue)모드")
            Spacer()
            if isGameStart{
                timerView
            }else{
                if showingCard{
                    cardView
                }else{
                    buttonView
                }
            }
            Spacer()
            
            
            NavigationLink(
                destination: ChoiceView(data: data, list: $list, rootIsActive: $rootIsActive),
                isActive: $isGameEnd
            ) {
                EmptyView()
            }.isDetailLink(false)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement:.navigationBarTrailing){
                Button("재설정"){
                    dismiss()
                }
            }
        }
        .onAppear {
            list = Data(subject: subject, members: members, mode: mode).list
        }
    }
    
    var cardView: some View {
        VStack(spacing: 20){
            Text(list[index])
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.black)
            HStack{
                Text("당신의 번호는")
                Text("\(index + 1)번")
                    .bold()
                Text("입니다.")
            }

            Text("번호를 꼭 기억해주세요")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button("확인완료"){
                showingCard = false
                index += 1
                if index == members {
                    isGameStart = true
                }
            }
            .padding()
            .padding([.horizontal], 20)
            .background(Color(red: 0, green: 0.5, blue: 0))
            .foregroundColor(.white)
            .font(.title2)
            .clipShape(Capsule())
            .shadow(color: .gray, radius: 5, x: 5, y: 5)
            
        }
        
        
    }
    
    var buttonView: some View {
        Button("제시어 확인하기"){
            showingCard = true
        }
        .padding()
        .padding([.horizontal], 20)
        .background(Color(red: 0, green: 0, blue: 0.5))
        .foregroundColor(.white)
        .font(.title2)
        .clipShape(Capsule())
        .shadow(color: .gray, radius: 5, x: 5, y: 5)
    }
    
    var timerView: some View {
        ZStack{
            Circle()
               .strokeBorder(
                   AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
               )
               .padding()
            VStack{
                Text("\(remainingTime)초")
                    .font(.largeTitle)
                    .onReceive(timer){ _ in
                        if remainingTime > 1 {
                            remainingTime -= 1
                        }else{
                            isGameEnd = true
                        }
                    }
                Text("남았습니다.")
                
                Button("라이어 맞추기", role: .destructive){
                    isGameEnd = true
                }.buttonStyle(.borderedProminent)
                
                
            }

        }
            
            
    }

}


