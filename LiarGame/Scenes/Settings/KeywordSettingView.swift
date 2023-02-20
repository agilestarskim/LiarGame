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
    @State private var subjects: [String] = []
    @State private var showingAlert = false
    let navigator: LinkNavigatorType
    
    var body: some View {
        List {
            Section {
                ForEach(game.subjects + subjects, id: \.self) { subject in
                    NavigationLink(subject, destination: EmptyView())
                }
                Button("추가"){
                    var count = subjects.count
                    var title = "커스텀 \(count)"
                    while(subjects.contains(title)) {
                        count += 1
                        title = "커스텀 \(count)"
                    }
                    subjects.append(title)
                }
            } header: {
                Text("주제")
            }
        }
        .navigationTitle("나만의 키워드 만들기")
        .toolbar {
            Button("초기화") {
                showingAlert = true
            }
        }
        .alert("초기화 하시겠습니까?", isPresented: $showingAlert) {
            Button("취소", role: .cancel){}
            Button("초기화", role: .destructive){}
        }
    }
}

struct KeywordSettingtRouteBuilder: RouteBuilder {
  var matchPath: String { "keywordSetting" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          KeywordSettingView(navigator: navigator)
      }
    }
  }
}


struct KeywordSettingView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordSettingView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))
            .environmentObject(Game())
    }
}
