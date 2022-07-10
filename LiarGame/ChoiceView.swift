//
//  ChoiceView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/01.
//

import SwiftUI

struct ChoiceView: View {
    let data: Data
    @Binding var list: [String]
    @Binding var rootIsActive: Bool
    @State private var isSpyModeOn = false 
    var body: some View {
        ScrollView {
            switch data.mode {
            case .normal: normalAndFoolView
            case .spy: spyView
            case .fool: normalAndFoolView
            }
        }
        
        .navigationBarBackButtonHidden(true)
    }
    
    var normalAndFoolView: some View {
        VStack{
            Text("라이어를 맞춰주세요")
                .font(.largeTitle.bold())
            listButtonView
            
        }
    }
    
    var spyView: some View {
        VStack{
            Text(isSpyModeOn ? "스파이를 맞춰주세요" : "라이어를 맞춰주세요")
                .font(.largeTitle.bold())
            listButtonView
            if isSpyModeOn{
                Text("스파이를 잘못 고를 시 바로 패배합니다.")
            }
        }
        .toolbar{
                Toggle("스파이 찾기", isOn: $isSpyModeOn)
                .toggleStyle(.switch)
            
        }
    }
    
    var listButtonView: some View {
        ForEach(0..<data.list.count, id: \.self) { i in
            NavigationLink(destination:
                            ResultView(
                                data: data,
                                list: $list,
                                isCorrect: isCorrect(i),
                                pointedPerson: i,
                                rootIsActive: $rootIsActive,
                                isSpyModeOn: $isSpyModeOn
                            )
                           
            ){
                Text("\(i + 1)번")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding()
                    .background(isSpyModeOn ? .red : .blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
            }
        }
    }
    
    func isCorrect(_ index: Int) -> Bool {
        switch data.mode {
        case .normal:
            return list[index].contains("라이어")
        case .spy:
            if isSpyModeOn{
                return list[index].contains("스파이")
            }else{
                return list[index].contains("라이어")
            }
            
        case .fool:
            var hash = [String : Int]()
            for word in list {
                hash[word] = hash[word, default: 0] + 1
            }
            return hash[list[index], default: -1] == 1
        }
       
    }
}

