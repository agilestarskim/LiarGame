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
    @FocusState private var isFocused: Bool
    
    let normalDescription = "라이어를 찾으면 라이어는 정답을 맞출 기회가 한 번 주어집니다. 정답을 맞추면 라이어 승리, 틀리면 시민 승리입니다."
    let spyDescription = "스파이에게도 키워드를 제공합니다. 스파이는 라이어가 정답을 유추할 수 있도록 질문합니다. 스파이는 라이어를 도와 라이어팀이 승리하도록 이끌어야합니다. 스파이가 지목당하면 시민이 승리합니다."
    let foolDescription = "라이어는 자신이 라이어인지 모릅니다. 라이어는 일반 시민들과 다른 키워드가 주어집니다."
    
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
                    Text(self.normalDescription)
                case .spy:
                    Text(self.spyDescription)
                case .fool:
                    Text(self.foolDescription)
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
                Stepper("제한시간 \(game.time) 분", value: $game.time, in: 1...10)
                Toggle("효과음 켜기", isOn: $game.soundEffect)
            }
            
            Section(content: {
                Button {
                    game.resetGame()
                    navigator.next(paths: ["game"], items: [:], isAnimated: true)
                } label: {
                    Text("게임시작")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
                
                .disabled(checkSpy || checkLiar || checkName)
            }, footer: {
                if(checkSpy) {
                    Text("스파이 모드는 5명부터 가능합니다.")
                        .foregroundColor(.red)
                } else if (checkLiar) {
                    Text("라이어의 수는 3명당 1명씩 늘릴 수 있습니다.")
                        .foregroundColor(.red)
                } else if (checkName) {
                    Text("참가자의 이름을 모두 입력해 주세요.")
                }
            })
        })
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("세팅")        
    }
    //스파이모드에서 전체인원이 5명 이하일 때 게임시작 방지
    var checkSpy: Bool {
        game.gameMode == .spy && game.users.count < 5
    }
    //라이어의 수가 전체 인원의 3분의 1보다 클 때 게임시작 방지
    var checkLiar: Bool {
        Int(game.users.count / 3) < game.numberOfLiars
    }
    //이름지정모드에서 이름을 지정하지 않았을 때 게임시작 방지
    var checkName: Bool {
        game.namingMode == .name && game.users.filter { $0.name == ""}.count != 0
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
