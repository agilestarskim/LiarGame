//
//  SystemView.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/22.
//

import SwiftUI

struct SystemView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) private var dismiss
    let subject: String
    @State private var showingBackAlert = false
    var body: some View {
        List {
            Section {
                Text(subject)
            }
            
            Section {
                
            }
            
            Section {
                Button("저장") {
                    game.keywordsContainer.saveSystemKeywords([:])
                }
                //TODO: title이 이미 존재하는지 확인
                //TODO: 키워드가 10개 이상인지 확인
            }
        }
        .navigationTitle("키워드 수정")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("취소") {
                    showingBackAlert = true
                }
                .alert("취소하시겠습니까?", isPresented: $showingBackAlert) {
                    Button("취소하기", role: .destructive){ dismiss() }
                    Button("계속하기", role: .cancel){}
                } message: {
                    Text("취소하시면 작성한 데이터는 모두 사라집니다.")
                }

            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SystemView_Previews: PreviewProvider {
    static var previews: some View {
        SystemView(subject: "")
    }
}
