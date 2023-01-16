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
    @FocusState private var isFocused: Bool
    let navigator: LinkNavigatorType
    var body: some View {
        Form(content: {
            Section {
                Picker(game.subject.rawValue, selection: $game.subject){
                    ForEach(Subjects.allCases, id: \.self) { subject in
                        Text(subject.localizedName)
                    }
                }
            } 
            
            Section(content: {
                Picker("모드", selection: $game.gameMode){
                    ForEach(GameMode.allCases, id: \.self) { value in
                        Text(value.localizedName)
                    }
                }.pickerStyle(.segmented)
            }, footer: {
                switch game.gameMode {
                case .normal:
                    Text(vm.normalDescription)
                case .spy:
                    Text(vm.spyDescription)
                case .fool:
                    Text(vm.foolDescription)
                }
            })
            
            Section {
                Picker("네이밍모드", selection: $game.namingMode){
                    ForEach(NamingMode.allCases, id: \.self) { value in
                        Text(value.localizedName)
                    }
                }.pickerStyle(.segmented)
                switch game.namingMode {
                case .number:                    
                    Stepper("인원 수 \(game.users.count)명") {
                        game.addUser()
                    } onDecrement: {
                        game.removeUserLast()
                    }

                case .name:
                    ForEach(game.users.indices, id: \.self) { index in
                        HStack{
                            Text("\(index + 1)")
                            TextField("이름을 입력하세요", text: $game.users[index].name)
                                .id(index)
                                .focused($isFocused)
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    withAnimation{
                                        //포커스 되어있는 상태에서 뷰가 사라지면 크래쉬일어남
                                        isFocused = false
                                        game.removeUser(index: index)
                                    }
                                }
                        }
                    }
                    HStack{
                        Spacer()
                        Button("추가"){withAnimation{game.addUser()}}
                            .disabled(game.users.count > 19)
                        Spacer()
                    }
                }            
            }
            
            Section {
                Stepper("라이어 수 \(game.numberOfLiars)명", value: $game.numberOfLiars, in: 1...10)
                if game.numberOfLiars > 1 {
                    Picker("라이어모드", selection: $game.liarsMode){
                        ForEach(LiarsMode.allCases, id: \.self) { value in
                            Text(value.localizedName)
                        }
                    }.pickerStyle(.segmented)
                }
            } footer: {
                if game.liarsMode == .all && game.numberOfLiars > 1 {
                    Text("라이어를 모두 잡아야 승리입니다.")
                }
                else if game.liarsMode == .one && game.numberOfLiars > 1 {
                    Text("한 명의 라이어만 잡으면 승리입니다.")
                }
            }
            
            Section {
                Stepper("제한시간 \(game.time) 분", value: $game.time, in: 1...10)
            }
            
            Section(content: {
                Button("게임시작"){
                    game.resetGame()
                    navigator.next(paths: ["game"], items: [:], isAnimated: true)
                }
                .disabled(checkSpy || checkLiar)
            }, footer: {
                if(checkSpy){
                    Text("스파이 모드는 5명부터 가능합니다.")
                        .foregroundColor(.red)
                } else if (checkLiar){
                    Text("라이어의 수는 3명당 1명씩 늘릴 수 있습니다.")
                        .foregroundColor(.red)
                }
            })
        })
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("세팅")
    }
    
    var checkSpy: Bool {
        game.gameMode == .spy && game.users.count < 5
    }
    
    var checkLiar: Bool {
        Int(game.users.count / 3) < game.numberOfLiars
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
