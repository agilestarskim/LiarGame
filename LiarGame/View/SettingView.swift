//
//  SettingView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/06/30.
//

import LinkNavigator
import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var game: Game
    @StateObject private var vm =  ViewModel()
    let navigator: LinkNavigatorType
    var body: some View {
        
        Form(content: {
            Section {
                Picker("주제 : \(game.subject.rawValue)", selection: $game.subject){
                    ForEach(Subjects.allCases, id: \.self) { subject in
                        Text(subject.localizedName)
                    }
                }
            }
            
            Section(content: {
                Stepper("인원 수 \(game.numberOfMembers)", value: $game.numberOfMembers, in: 3...20)
                Stepper("제한시간 \(game.time) 분", value: $game.time, in: 1...10)
                Picker("모드", selection: $game.mode){
                    ForEach(Modes.allCases, id: \.self) { value in
                        Text(value.localizedName)
                    }
                }.pickerStyle(.segmented)
            }, footer: {
                switch game.mode {
                case .normal:
                    Text(vm.normalDescription)
                case .spy:
                    Text(vm.spyDescription)
                case .fool:
                    Text(vm.foolDescription)
                }
            })
            
            Section(content: {
                Button("게임시작"){
                    game.resetGame()
                    navigator.next(paths: ["game"], items: [:], isAnimated: true)
                }
                .disabled(game.mode == .spy && game.numberOfMembers < 5)
            }, footer: {
                if(game.mode == .spy && game.numberOfMembers < 5){
                    Text("스파이 모드는 5명부터 가능합니다.")
                        .foregroundColor(.red)
                }
            })
        })
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("세팅")
    }
}

struct SettingRouteBuilder: RouteBuilder {
  var matchPath: String { "setting" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          SettingView(navigator: navigator)
      }
    }
  }
}

struct SettingView_Previews: PreviewProvider {
    static let preview_game = Game()
    static var previews: some View {
        SettingView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))
            .environmentObject(preview_game)
    }
}
