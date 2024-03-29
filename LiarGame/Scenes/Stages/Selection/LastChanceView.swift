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
            //라이어가 여러 명일 때는 그냥 일괄적으로 표시
            if game.getLiarsIndexes.count > 1 {
                Text("You found all the liars.".localized)
                    .font(.largeTitle.bold())
                    .padding(.vertical, 30)
            }
            //라이어가 한 명일 때는 라이어 호명
            //라이어가 한 명이기 때문에 first 호출 가능
            else {
                switch game.namingMode {
                case .number:
                    Text("Number %d is a liar.".localized(with: game.getOneSelectedLiar + 1))
                        .font(.largeTitle.bold())
                        .padding(.vertical, 30)
                case .name:                    
                    Text("%@ is a liar.".localized(with: game.users[game.getOneSelectedLiar].name))
                        .font(.largeTitle.bold())
                        .padding(.vertical, 30)
                }
            }
            
            Text("The liar is given the last chance.".localized)
                .font(.title2)
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(game.wholeKeywords[game.subject, default: []], id:\.self){ candidate in
                    Button{
                        game.selectedCandidate = candidate
                        navigator.next(paths: ["result"], items: [:], isAnimated: true)
                    } label: {
                        Text(candidate)
                            .frame(width: 80, height: 50)
                            .minimumScaleFactor(0.5)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .onAppear{
            if game.soundEffect {
                SoundManager.instance.play(file: "hooray")
            }            
        }
        .navigationBarHidden(true)
    }
}

struct LastChanceRouteBuilder: RouteBuilder {
  var matchPath: String { "lastChance" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
        return WrappingController(matchPath: matchPath) {
          LastChanceView(navigator: navigator)
      }
    }
  }
}


struct LastChanceView_Previews: PreviewProvider {
    static let preview_game = Game()
    static var previews: some View {
        LastChanceView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))
            .onAppear {
                preview_game.selectedLiars = [0]
                
                preview_game.gameMode = .normal
                preview_game.numberOfLiars = 1
                preview_game.users[0].roll = .liar
                preview_game.users[1].roll = .none
                preview_game.users[2].roll = .none
                
                preview_game.users[0].name = "김민성"
                preview_game.users[1].name = "이시온"
                preview_game.users[2].name = "박준혁"
                preview_game.namingMode = .name
                preview_game.answer = "국회의원"
                preview_game.selectedCandidate = ""
                
            }
            .environmentObject(preview_game)
    }
}
