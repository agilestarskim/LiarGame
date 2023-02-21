//
//  KeywordDetail.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/20.
//

import SwiftUI

struct KeywordDetailView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) private var dismiss
    let subject: String
    let isSystemKeywords: Bool
    @State private var showingBackAlert = false
    @State private var title = ""
    var body: some View {
        List {
            Section {
                if isSystemKeywords{
                    Text(subject)
                } else {
                    TextField("제목을 입력하세요 예)스포츠 ", text: $title)
                }
            }
            
            Section {
                
            }
            
            Section {
                Button("저장") {
                    if self.isSystemKeywords {
                        game.keywordsContainer.saveSystemKeywords([:])
                    } else {
                        game.keywordsContainer.saveCustomKeywords([:])
                    }
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

struct KeywordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordDetailView(subject: "직업", isSystemKeywords: false)
    }
}
