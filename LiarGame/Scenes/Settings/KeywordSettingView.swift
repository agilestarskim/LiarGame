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
    let navigator: LinkNavigatorType
    
    var body: some View {
        List {
            Section {
                ForEach(Subjects.allCases, id: \.self) { subject in
                    Text(subject.localizedName)
                }
            } header: {
                Text("기본")
            }
            
            Section {
                
                Button("추가"){
                    
                }
            } header: {
                Text("사용자")
            }
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
    }
}
