//
//  KeywordSettingView.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/20.
//

import LinkNavigator
import SwiftUI

struct KeywordSettingView: View {
    @EnvironmentObject var game: Game
    @State private var showingResetAlert = false
    
    var body: some View {
        List {
            Section {
                ForEach(game.keywordsContainer.systemSubjects, id: \.self) { subject in
                    NavigationLink(subject, destination: SystemView(subject: subject))
                }
                
            } header: {
                Text("시스템 제공")
            }
            
            Section {
                ForEach(game.keywordsContainer.customSubjects, id: \.self) { subject in
                    NavigationLink(subject) {
                        CustomView(subject: subject)
                    }
                }
                NavigationLink {
                    CustomView(subject: "")
                } label: {
                    Text("추가")
                        .foregroundColor(.blue)
                }
                
            } header: {
                Text("나만의 키워드")
            }
        }
        .navigationTitle("나만의 키워드 만들기")
        .toolbar {
            Button("초기화") {
                showingResetAlert = true
            }
        }
        .alert("초기화하시겠습니까?", isPresented: $showingResetAlert) {
            Button("취소", role: .cancel){}
            Button("초기화", role: .destructive){}
        }
    }
}

struct KeywordSettingView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordSettingView()
            .environmentObject(Game())
    }
}
