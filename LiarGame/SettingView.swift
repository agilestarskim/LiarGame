//
//  SettingView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/06/30.
//

import SwiftUI
enum Mode: String, Equatable, CaseIterable {
    case normal = "일반"
    case spy = "스파이"
    case fool = "바보"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
struct SettingView: View {
    
    
    let subjects = ["물건", "직업", "동물", "국가", "가수", "장소", "음식"]
    
    let normalDescription = "라이어는 한명입니다. 라이어를 찾으면 라이어는 정답을 맞출 기회가 한 번 주어집니다. 정답을 맞추면 라이어 승리, 틀리면 시민 승리입니다. 물론 라이어를 맞추지 못하면 라이어 승리입니다."
    let spyDescription = "라이어 한명, 스파이 한명이 존재합니다. 스파이에게도 키워드를 제공합니다. 스파이는 라이어가 정답을 유추할 수 있도록 질문합니다. 라이어가 이기면 스파이도 같이 이깁니다. 스파이가 지목당하면 라이어와 스파이 모두 패배합니다."
    let foolDescription = "라이어는 자신이 라이어인지 모릅니다. 라이어는 일반 시민들과 다른 키워드가 주어집니다."
    
    @State private var members = 3
    @State private var time = 2
    @State private var mode: Mode = .normal
    @State private var subject = "직업"
    @State var isActive : Bool = false
    var body: some View {
        NavigationView{
            Form {
                Section {
                    Picker("주제 : \(subject)", selection: $subject ){
                        ForEach(subjects, id: \.self) { subject in
                            Text(subject)
                        }
                    }
                }
                
                Section {
                    Stepper("인원 수 \(members)", value: $members, in: 3...20)
                    Stepper("제한시간 \(time)분", value: $time, in: 1...10)
                    Picker("모드", selection: $mode){
                        ForEach(Mode.allCases, id: \.self) { value in
                            Text(value.localizedName)
                        }
                    }.pickerStyle(.segmented)
                } footer: {
                    switch mode {
                    case .normal:
                        Text(normalDescription)
                    case .spy:
                        Text(spyDescription)
                    case .fool:
                        Text(foolDescription)
                    }
                }
                
                Section {
                    NavigationLink(destination: GameView(mode: mode, members: members, subject: subject, time: time, rootIsActive: $isActive), isActive: $isActive){
                        Button("게임시작"){}
                    }
                    .isDetailLink(false)
                    .disabled(mode == .spy && members < 5)
                } footer: {
                    if(mode == .spy && members < 5){
                        Text("스파이 모드는 5명부터 가능합니다.")
                            .foregroundColor(.red)
                    }
                }
                
                
            }
            .navigationTitle("세팅")
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
