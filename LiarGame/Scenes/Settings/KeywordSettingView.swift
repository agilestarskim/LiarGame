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
                Text("System keywords".localized)
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
                    Text("Add".localized)
                        .foregroundColor(.blue)
                }
                
            } header: {
                Text("Custom keywords".localized)
            }
        }
        .navigationTitle("Make your own keyword".localized)
        .toolbar {
            Button("Reset".localized) {
                showingResetAlert = true
            }
        }
        .confirmationDialog("Reset keywords".localized, isPresented: $showingResetAlert) {
            Button("Reset system Keywords".localized){
                reset(for: .system)
            }
            Button("Reset custom Keywords".localized){
                reset(for: .custom)
            }
            Button("Reset all keywords".localized){
                reset(for: .all)
            }
            Button("Cancel".localized, role: .cancel){}
        }
        .toast(message: "It has been reset.", isShowing: $showingConfirmToast, config: .init())
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
