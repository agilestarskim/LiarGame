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
    @StateObject private var vm = ViewModel()
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
            if vm.isGameStart{
                timerView
            }else{
//                if vm.showingCard{
//                    cardView
//                }else{
//                    buttonView
//                }
                ZStack {
                    ForEach(game.users) { user in
                        
                    }
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
                    Text("You are LIAR".localized)
                        .font(.largeTitle.bold())
                }
                
            case .spy:
                Text("You are SPY".localized)
                    .font(.largeTitle.bold())
                Text(game.answer)
                    .font(.title)
            }
            
            switch game.namingMode {
            case .name:
                Text("-\(game.users[vm.index].name)-")
            case .number:
                HStack{
                    //TODO: 번호에 bold처리
                    Text("Your Number is %d".localized(with: vm.index + 1))
                }

                Text("Please remember the number.".localized)
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
                Text("Confirm".localized)
                    .myButtonStyle(color: Color(red: 0, green: 0.5, blue: 0), vertical: 20, horizontal: 20)
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
                    Text("Check keyword".localized)
                }
                .myButtonStyle(color: Color(red: 0, green: 0, blue: 0.5), vertical: 20, horizontal: 20)
                .shadow(color: .gray, radius: 5, x: 5, y: 5)
            case .name:
                Button {
                    vm.showingCard = true
                } label: {
                    Text("%@'s keyword".localized(with: game.users[vm.index].name))
                }
                .myButtonStyle(color: Color(red: 0, green: 0, blue: 0.5), vertical: 20, horizontal: 20)
                .shadow(color: .gray, radius: 5, x: 5, y: 5)
            }
        }
    }
    
    var timerView: some View {
        VStack{
            Spacer()            
            Text("%d seconds".localized(with: vm.remainingTime))
                .font(.largeTitle)
                .onReceive(vm.timer){ _ in
                    if vm.remainingTime > 1 {
                        vm.remainingTime -= 1
                    }else{
                        vm.isGameEnd = true
                    }
                }
            Spacer()
            Button {
                vm.isGameEnd = true
            } label: {
                Text("Vote for liars".localized)
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

struct IntroRouteBuilder: RouteBuilder {
  var matchPath: String { "intro" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
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

