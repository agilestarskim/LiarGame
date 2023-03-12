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
    @EnvironmentObject private var store: Store
    @FocusState private var isFocused: Bool
    @State private var showingRuleBook = false
    
    let navigator: LinkNavigatorType
    var body: some View {
        Form {
            Section {
                Picker("Category: %@".localized(with: game.tempSubject), selection: $game.tempSubject){
                    ForEach(game.systemSubjects, id: \.self) { subject in
                        Text(subject)
                    }
                    ForEach(game.customSubjects, id: \.self) { subject in
                        Text(subject)
                    }
                }
                
                Button {
                    if store.isPurchased {
                        navigator.next(paths: ["keyword"], items: [:], isAnimated: true)
                    } else {
                        navigator.next(paths: ["purchase"], items: [:], isAnimated: true)
                    }
                } label: {
                    HStack {
                        Text("new")
                            .foregroundColor(.black)
                            .bold()
                            .padding(5)
                            .background(.yellow)
                            .cornerRadius(5)
                        Spacer()
                        Text("Make your own keyword".localized)
                            .foregroundColor(.black)
                            .bold()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.gray)
                    }
                }
                
                
            }
            
            Section {
                Picker("Mode".localized, selection: $game.gameMode){
                    ForEach(GameMode.allCases, id: \.self) { value in
                        Text(value.localizedName)
                    }
                }.pickerStyle(.segmented)
            } footer: {
                switch game.gameMode {
                case .normal:
                    Text("normalDescription".localized)
                case .spy:
                    Text("spyDescription".localized)
                case .fool:
                    Text("foolDescription".localized)
                }
            }
            
            Section {
                Picker("Naming mode".localized, selection: $game.namingMode){
                    ForEach(NamingMode.allCases, id: \.self) { value in
                        Text(value.localizedName)
                    }
                }.pickerStyle(.segmented)
                switch game.namingMode {
                case .number:
                    Stepper("Players: %d".localized(with: game.users.count)) {
                        game.addUser()
                    } onDecrement: {
                        game.removeUserLast()
                    }
                    
                case .name:
                    ForEach(game.users.indices, id: \.self) { index in
                        HStack{
                            Text("\(index + 1)")
                            TextField("Please enter the name".localized, text: $game.users[index].name)
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
                        Button("Add".localized){withAnimation{game.addUser()}}
                            .disabled(game.users.count > 19)
                        Spacer()
                    }
                }
            }
            
            Section {
                Stepper("Liars: %d".localized(with: game.numberOfLiars), value: $game.numberOfLiars, in: 1...10)
                Stepper("Time limit: %d".localized(with: game.time), value: $game.time, in: 1...10)
                Toggle("Turn on sound effects".localized, isOn: $game.soundEffect)
            }
            
            Section {
                Button {
                    game.resetGame()
                    navigator.next(paths: ["intro"], items: [:], isAnimated: true)
                } label: {
                    Text("Game Start".localized)
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    
                }
                .disabled(checkSpy || checkLiar || checkName)
            } footer: {
                if(checkSpy) {
                    Text("Spy mode is available for at least 5 people".localized)
                        .foregroundColor(.red)
                } else if (checkLiar) {
                    Text("The number of liars can be increased by one per three people.".localized)
                        .foregroundColor(.red)
                } else if (checkName) {
                    Text("Please enter all the names of the participants.".localized)
                        .foregroundColor(.red)
                }
            }
        }
        .toolbar {
            Button("How to".localized) {
                showingRuleBook = true
            }
        }
        .sheet(isPresented: $showingRuleBook) {
            RuleBookView()
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Settings".localized)
        .onAppear {
            game.resetRoll()
            game.resetInGameSetting()
        }
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
      return WrappingController(matchPath: matchPath) {
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
