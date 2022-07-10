//
//  ResultView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/04.
//

import SwiftUI

struct ResultView: View {
    let data: Data
    @Binding var list: [String]
    let isCorrect: Bool
    let pointedPerson: Int
    @Binding var rootIsActive: Bool
    @Binding var isSpyModeOn: Bool
    var body: some View {
        VStack{
            //모드에 상관없이 라이어 또는 스파이가 맞으면
            if isCorrect {
                //스파이 찾았을 때
                if isSpyModeOn{
                    Text("\(pointedPerson + 1)번은 스파이 입니다")
                        .font(.largeTitle)
                    Text("시민승리!!")
                        .font(.largeTitle.bold())
                    LottieView(fileName: "celebration")
                }
                //라이어 찾았을 때
                else{
                    LastChanceView(data: data, list: $list, pointedPerson: pointedPerson + 1)
                }
                
            }
            //모드에 상관없이 라이어 또는 스파이가 아니면
            else {
                //스파이가 아닐 때
                if isSpyModeOn{
                    Text("\(pointedPerson + 1)번은 스파이가 아닙니다")
                        .font(.largeTitle)
                    Text("스파이 라이어 승리!!")
                        .font(.largeTitle.bold())
                    LottieView(fileName: "lose")
                }
                //라이어가 아닐 때
                else{
                    Text("\(pointedPerson + 1)번은 라이어가 아닙니다")
                        .font(.largeTitle)
                    Text("라이어 승리!!")
                        .font(.largeTitle.bold())
                    LottieView(fileName: "lose")
                }
            }
            Button("다시하기"){
                rootIsActive = false
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

