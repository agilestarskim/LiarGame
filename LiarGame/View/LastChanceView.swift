//
//  LastChanceView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/04.
//
import LinkNavigator
import SwiftUI

struct LastChanceView: View {
    let columns = [GridItem(.adaptive(minimum: 100))]
    @EnvironmentObject var game: Game
    let navigator: LinkNavigatorType
    var body: some View {
        ScrollView {
            Text("\((game.selectedLiar ?? 0) + 1)번은 라이어입니다.")
                .font(.largeTitle.bold())
                .padding(.vertical, 30)
            Text("라이어에게 마지막 기회가 주어집니다.")
                .font(.title2)
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(game.candidates[game.subject, default: []], id:\.self){ candidate in
                    Button{
                        game.selectedCandidate = candidate
                        navigator.next(paths: ["result"], items: [:], isAnimated: true)
                    } label: {
                        Text(candidate)
                            .frame(width: 80, height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

struct LastChanceRouteBuilder: RouteBuilder {
  var matchPath: String { "lastChance" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          LastChanceView(navigator: navigator)
      }
    }
  }
}


struct LastChanceView_Previews: PreviewProvider {
    static let preview_game = Game()
    static var previews: some View {
        LastChanceView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))            
            .environmentObject(preview_game)
    }
}
