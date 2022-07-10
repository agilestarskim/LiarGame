//
//  LastChanceView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/04.
//

import SwiftUI

struct LastChanceView: View {
    let data: Data
    @Binding var list: [String]
    let columns = [GridItem(.adaptive(minimum: 100))]
    let pointedPerson: Int
    @State private var showingChances = true
    @State private var isCorrect = true
    var body: some View {
        if showingChances{
            ScrollView {
                Text("\(pointedPerson)번은 라이어입니다.")
                    .font(.largeTitle)
                Text("라이어에게 마지막 기회가 주어집니다.")
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(data.dict[data.subject, default: []], id:\.self){ word in
                        Button{
                            isCorrect = check(word)
                            showingChances = false
                        } label: {
                            Text(word)
                                .frame(width: 80, height: 50)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
        }else{
            if isCorrect {
                VStack{
                    Text("라이어가 정답을 맞췄습니다!!")
                        .font(.title)
                    Text("라이어 승리!!!")
                        .font(.title.bold())
                    LottieView(fileName: "celebration")
                }.padding()
                
                
            }else{
                VStack{
                    Text("틀렸습니다.")
                        .font(.title)
                    Text("시민 승리!!!")
                        .font(.title.bold())
                    LottieView(fileName: "wrong")
                }.padding()
                
            }
        }
    }
    
    func check(_ word: String) -> Bool{
        var hash = [String : Int]()
        for word in list{
            hash[word] = hash[word, default: 0] + 1
        }
        let answer = hash.sorted{ $0.value > $1.value }.first?.key
        if answer == word {
            return true
        }else{
            return false
        }
    }
}
