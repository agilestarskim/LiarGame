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
    @State private var showingConfirmToast = false
    
    var body: some View {
        List {
            Section {
                ForEach(game.keyword.systemSubjects, id: \.self) { subject in
                    NavigationLink {
                        SystemView(title: subject, keywords: game.keyword.systemKeywords[subject] ?? [])
                    } label: {
                        Text(subject)
                    }
                }
                
            } header: {
                Text("시스템 제공")
            }
            
            Section {
                ForEach(game.keyword.customSubjects, id: \.self) { subject in
                    NavigationLink(subject) {
                        CustomView(title: subject, keywords: game.keyword.customKeywords[subject] ?? [])
                    }
                }
                NavigationLink {
                    CustomView(title: "", keywords: ["", "", "", "", "", "", "", "", "", ""])
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
        .confirmationDialog("키워드를 초기화합니다.", isPresented: $showingResetAlert) {
            Button("기본제공 키워드 초기화"){
                reset(for: .system)
            }
            Button("나만의 키워드 초기화"){
                reset(for: .custom)
            }
            Button("전체 초기화"){
                reset(for: .all)
            }
            Button("취소", role: .cancel){}
        }
        .toast(message: "초기화되었습니다.", isShowing: $showingConfirmToast, config: .init())
    }
    
    func reset(for resetMode: Keyword.RemoveMode) {
        switch resetMode {
        case .system:
            game.keyword.removeFromUserDefaults(for: .system)
        case .custom:
            game.keyword.removeFromUserDefaults(for: .custom)
        case .all:
            game.keyword.removeFromUserDefaults(for: .all)
        }
        game.keyword = Keyword()
        showingConfirmToast = true
    }
}

struct KeywordSettingView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordSettingView()
            .environmentObject(Game())
    }
}
