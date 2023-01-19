//
//  GameView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/01.
//

import LinkNavigator
import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: Game
    @StateObject private var vm = ViewModel()
    let navigator: LinkNavigatorType
    var body: some View {
        VStack{
            Text("\(game.subject.rawValue)")
                .font(.title.bold())
                .padding()
            Text("\(game.gameMode.rawValue)모드")
            Spacer()
            if vm.isGameStart{
                timerView
            }else{
                if vm.showingCard{
                    cardView
                }else{
                    buttonView
                }
            }
            Spacer()
        }
        .onAppear {
            vm.remainingTime = game.time * 60
            _ = vm.timer.upstream.autoconnect()
        }
        .onDisappear {
            vm.timer.upstream.connect().cancel()
        }
        .onChange(of: vm.isGameEnd) { isGameEnd in
            if isGameEnd {
                navigator.next(paths: ["choice"], items: [:], isAnimated: true)
            }
        }
    }
    
    var cardView: some View {
        VStack(spacing: 20){
            switch game.users[vm.index].roll {
            case .none:
                Text(game.answer)
                    .font(.largeTitle.bold())
            case .liar:
                if game.gameMode == .fool {
                    Text(game.wrongAnswerForFool)
                        .font(.largeTitle.bold())
                } else {
                    Text("라이어 당첨")
                        .font(.largeTitle.bold())
                }
                
            case .spy:
                Text("스파이 당첨")
                    .font(.largeTitle.bold())
                Text(game.answer)
                    .font(.title)
            }
            
            switch game.namingMode {
            case .name:
                Text("-\(game.users[vm.index].name)-")
            case .number:
                HStack{
                    Text("당신의 번호는")
                    Text("\(vm.index + 1)번")
                        .bold()
                    Text("입니다.")
                }

                Text("번호를 꼭 기억해주세요")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Button {
                vm.showingCard = false
                vm.index += 1
                if vm.index == game.users.count {
                    vm.isGameStart = true
                }
            } label: {
                Text("확인완료")
                    .padding()
                    .padding([.horizontal], 20)
                    .background(Color(red: 0, green: 0.5, blue: 0))
                    .foregroundColor(.white)
                    .font(.title2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray, radius: 5, x: 5, y: 5)
            }            
        }
    }
    
    var buttonView: some View {
        VStack{
            switch game.namingMode{
            case .number:
                Button {
                    vm.showingCard = true
                } label: {
                    Text("제시어 확인하기")
                        .padding()
                        .padding([.horizontal], 20)
                        .background(Color(red: 0, green: 0, blue: 0.5))
                        .foregroundColor(.white)
                        .font(.title2)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray, radius: 5, x: 5, y: 5)
                }
            case .name:
                Button {
                    vm.showingCard = true
                } label: {
                    VStack(spacing: 10){
                        Text("\(game.users[vm.index].name)의")
                            .bold()
                        Text("제시어 확인하기")
                    }
                    .padding()
                    .padding([.horizontal], 20)
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .foregroundColor(.white)
                    .font(.title2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray, radius: 5, x: 5, y: 5)
                }
            }
        }
    }
    
    var timerView: some View {
        VStack{
            Spacer()
            Text("\(vm.remainingTime)초")
                .font(.largeTitle)
                .onReceive(vm.timer){ _ in
                    if vm.remainingTime > 1 {
                        vm.remainingTime -= 1
                    }else{
                        vm.isGameEnd = true
                    }
                }
            Text("남았습니다.")
            Spacer()
            Button {
                vm.isGameEnd = true
            } label: {
                Text("라이어 맞추기")
                    .padding()
                    .padding([.horizontal], 20)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .font(.title2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray, radius: 5, x: 5, y: 5)
            }
            .padding(.top, 50)
            
        }
        .onChange(of: vm.remainingTime){ remainingTime in
            //10초에 틱톡 소리가 나오고 1초에 벨소리가 울림
            if remainingTime == 10 {
                SoundManager.instance.play(file: "ticktock")
            } else if remainingTime == 1 {
                SoundManager.instance.stop(file: "ticktock")
                SoundManager.instance.play(file: "bell")
            }
        }
    }
}

struct GameRouteBuilder: RouteBuilder {
  var matchPath: String { "game" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          GameView(navigator: navigator)
      }
    }
  }
}


struct GameView_Previews: PreviewProvider {
    static let preview_game = Game()
    static var previews: some View {
        GameView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))
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


