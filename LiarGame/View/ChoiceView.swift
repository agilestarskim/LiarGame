//
//  ChoiceView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/01.
//

import LinkNavigator
import SwiftUI

struct ChoiceView: View {
    @EnvironmentObject var game: Game
    let navigator: LinkNavigatorType
    var body: some View {
        ScrollView {
            if game.mode == .spy {
                spyChoiceView
            } else {
                choiceView
            }
        }
        .navigationBarHidden(true)
    }
    
    var choiceView: some View {
        VStack {
            Text("라이어를 맞춰주세요")
                .font(.largeTitle.bold())
                .padding(.top)
            ForEach(0..<game.numberOfMembers, id: \.self) { selectedNumber in
                Button {
                    game.selectedLiar = selectedNumber
                    if checkLiar() {
                        navigator.next(paths: ["lastChance"], items: [:], isAnimated: true)
                    } else {
                        navigator.next(paths: ["result"], items: [:], isAnimated: true)
                    }
                } label: {
                    Text("\(selectedNumber + 1)번")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                }
                
            }
        }
    }
    
    var spyChoiceView: some View {
        VStack {
            Text("정답을 맞춰주세요")
                .font(.title.bold())
                .padding(.top, 30)
            Text("라이어 스파이 둘 중 하나만 맞춰도 시민 승리")
                .font(.title3)
                .padding(.vertical, 20)
            HStack {
                VStack{
                    Text("라이어")
                        .font(.largeTitle)
                    ForEach(0..<game.numberOfMembers, id: \.self) { selectedNumber in
                        Button {
                            game.selectedLiar = selectedNumber
                            
                            if checkLiar() {
                                navigator.next(paths: ["lastChance"], items: [:], isAnimated: true)
                            } else {
                                navigator.next(paths: ["result"], items: [:], isAnimated: true)
                            }
                        } label: {
                            Text("\(selectedNumber + 1)번")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .padding()
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding()
                        }
                        
                    }
                }
                
                VStack{
                    Text("스파이")
                        .font(.largeTitle)
                    ForEach(0..<game.numberOfMembers, id: \.self) { selectedNumber in
                        Button {
                            game.selectedSpy = selectedNumber
                            navigator.next(paths: ["result"], items: [:], isAnimated: true)
                        } label: {
                            Text("\(selectedNumber + 1)번")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .padding()
                                .background(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding()
                        }
                        
                    }
                }
            }
        }
    }
    
    func checkLiar() -> Bool {
        if game.selectedLiar == game.liar {
            return true
        } else {
            return false
        }
    }
}

struct ChoiceRouteBuilder: RouteBuilder {
  var matchPath: String { "choice" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          ChoiceView(navigator: navigator)
      }
    }
  }
}


struct ChoiceView_Previews: PreviewProvider {
    static let preview_game = Game()
    static var previews: some View {
        ChoiceView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))
            .onAppear{
                preview_game.mode = .normal
            }
            .environmentObject(preview_game)
    }
}
