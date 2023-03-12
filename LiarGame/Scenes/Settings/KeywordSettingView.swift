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
    @EnvironmentObject var store: Store
    @State private var showingResetAlert = false
    @State private var showingConfirmToast = false
    let navigator: LinkNavigatorType
    
    var body: some View {
        List {
            Section {
                ForEach(game.systemSubjects, id: \.self) { subject in
                    NavigationLink {
                        SystemView(title: subject, keywords: game.systemKeywords[subject] ?? [])
                    } label: {
                        Text(subject)
                    }
                }
                
            } header: {
                Text("System keywords".localized)
            }
            
            Section {
                ForEach(game.customSubjects, id: \.self) { subject in
                    NavigationLink(subject) {
                        CustomView(title: subject, keywords: game.customKeywords[subject] ?? [])
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
            if store.isPurchased {
                Button("Reset".localized) {
                    showingResetAlert = true
                }
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
        .toast(message: "It has been reset.".localized, isShowing: $showingConfirmToast, config: .init())
    }
    
    func reset(for resetMode: Game.SetMode) {
        switch resetMode {
        case .system:
            game.reset(for: .system)
        case .custom:
            game.reset(for: .custom)
        case .all:
            game.reset(for: .all)
        }
        showingConfirmToast = true
    }
}

struct KeywordSettingRouteBuilder: RouteBuilder {
  var matchPath: String { "keyword" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      return WrappingController(matchPath: matchPath) {
          KeywordSettingView(navigator: navigator)
      }
    }
  }
}

struct KeywordSettingView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordSettingView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))
            .environmentObject(Game())
            .environmentObject(Store())
    }
}
