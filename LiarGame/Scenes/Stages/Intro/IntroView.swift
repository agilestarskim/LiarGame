//
//  GameView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/01.
//

import LinkNavigator
import SwiftUI

struct IntroView: View {
    @EnvironmentObject var game: Game
    @State var currentIndex = 0
    @State var isGameStart = false
    @State var isGameEnd = false
    
    let navigator: LinkNavigatorType
    var body: some View {
        VStack{
            Text("\(game.subject)")
                .font(.title.bold())
                .padding()
            HStack {
                Text(game.gameMode.localizedName)
                Text("Mode".localized)
            }
            Spacer()
            if isGameStart{
                TimerView(remainingTime: game.time * 60, isGameEnd: $isGameEnd)
            }else{
                ZStack {
                    ForEach(game.users) { user in
                        CardView(user: user, currentIndex: $currentIndex, isGameStart: $isGameStart)
                            .opacity(currentIndex == game.findUserIndex(of: user) ? 1 : 0)
                    }
                }
            }
            Spacer()
        }        
        .onChange(of: isGameEnd) { isGameEnd in
            if isGameEnd {
                navigator.next(paths: ["choice"], items: [:], isAnimated: true)
            }
        }
    }
}

struct IntroRouteBuilder: RouteBuilder {
  var matchPath: String { "intro" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
        return WrappingController(matchPath: matchPath) {
          IntroView(navigator: navigator)
      }
    }
  }
}


struct GameView_Previews: PreviewProvider {
    static let preview_game = Game()
    static var previews: some View {
        IntroView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))
            .onAppear {
                preview_game.users[0].roll = .liar
                preview_game.users[1].roll = .spy
                preview_game.users[0].name = "김민성"
                preview_game.users[1].name = "이시온"
                preview_game.users[2].name = "박준혁"
                preview_game.namingMode = .name
                preview_game.answer = "국회의원"
                preview_game.time = 1
            }
            .environmentObject(preview_game)
    }
}


