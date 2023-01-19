//
//  ResultView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/04.
//

import LinkNavigator
import SwiftUI

struct ResultView: View {
    @EnvironmentObject var game: Game
    @State private var showingRollTable = false
    let navigator: LinkNavigatorType
    var body: some View {
        VStack{
            Spacer()
            //시민이 스파이모드에서 스파이를 선택해서 스파이를 맞춤            
            if (game.selectedSpy != nil && game.selectedSpy == game.getSpyIndex) {
                citizenWinningView
            }
            //시민이 스파이를 선택하고 틀리거나 라이어를 선택하고 틀림
            else if (game.selectedSpy != nil && game.selectedSpy != game.getSpyIndex) || (game.selectedLiars != [] && game.selectedLiars != game.getLiarsIndexes) {
                //라이어 스파이 승리
                liarWinningView
            }
            //마지막 찬스에서 라이어가 정답을 맞춤
            else if game.selectedCandidate == game.answer {
                //라이어 승리
                lastChanceSuccess
            }
            //마지막 찬스에서 라이어가 정답을 맞추지 못함
            else if game.selectedCandidate != "" && game.selectedCandidate != game.answer {
                //시민 승리
                lastChanceFailure
            }
            Spacer()
            showingRollTableButton
            restartButton
            
        }
        .navigationBarHidden(true)
    }
    var citizenWinningView: some View {
        VStack(spacing: 30){
            Text("시민 승리!!")
                .font(.largeTitle.bold())         
          
            LottieView(fileName: "Dance")
                .frame(width: 300, height: 300)
            
            Text("잡았지롱")
                .font(.largeTitle.bold())            
        }
        .onAppear {
            if game.soundEffect {
                SoundManager.instance.play(file: "trumpet", volume: 0.5, speed: 1.4)
            }
        }
    }
    
    var liarWinningView: some View {
        VStack(spacing: 30) {
            Text(game.gameMode == .spy ? "라이어 스파이 승리!!" : "라이어 승리!!")
                .font(.largeTitle.bold())
            LottieView(fileName: "Laughing")
                .frame(width: 300, height: 300)
            Text("틀렸지롱")
                .font(.largeTitle.bold())
        }
        .onAppear {
            if game.soundEffect {
                SoundManager.instance.play(file: "laugh")
            }
        }
    }
    
    var lastChanceSuccess: some View {
        VStack(spacing: 30) {
            Text("라이어 승리!!")
                .font(.largeTitle.bold())
            Text("정답입니다.")
                .font(.title)
            LottieView(fileName: "Laughing")
                .frame(width: 300, height: 300)
            Text("맞췄지롱")
                .font(.largeTitle.bold())
        }
        .onAppear {
            if game.soundEffect {
                SoundManager.instance.play(file: "laugh")
            }
        }
    }
    
    var lastChanceFailure: some View {
        VStack(spacing: 30) {
            Text("시민 승리!!")
                .font(.largeTitle.bold())
            Text("정답이 아닙니다.")
                .font(.title)
            LottieView(fileName: "Twerking")
                .frame(width: 300, height: 300)
            Text("응 아니야")
                .font(.largeTitle.bold())
        }
        .onAppear {
            if game.soundEffect {
                SoundManager.instance.play(file: "noitsnot")
            }
        }
    }
    
    var showingRollTableButton: some View {
        Button {
            showingRollTable = true
        } label: {
            Text("라이어 확인")
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .padding()
                .background(.indigo)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
        }        
        .halfSheet(showSheet: $showingRollTable) {
            RollTableView()
                .environmentObject(game)
        }
    }
    
    var restartButton: some View {
        Button {
            navigator.backOrNext(path: "setting", items: [:], isAnimated: true)
        } label: {
            Text("다시하기")
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .padding()
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
        }        
    }
}

struct ResultRouteBuilder: RouteBuilder {
  var matchPath: String { "result" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      return WrappingController(matchingKey: matchPath) {
          ResultView(navigator: navigator)
      }
    }
  }
}


struct ResultView_Previews: PreviewProvider {
    static let preview_game = Game()
    static var previews: some View {
        ResultView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))
            .onAppear{
                //test
                
                //스파이를 맞춤
                //test1()
                //스파이 또는 라이어를 선택하고 틀림
                //test2()
                //라스트 찬스에서 라이어가 정답을 맞춤
                //test3()
                //라스트 찬스에서 라이어가 정답을 못맞춤
                test4()
            }
            .environmentObject(preview_game)
    }
    
    static func test1() {
        preview_game.gameMode = .spy
        preview_game.selectedSpy = 1
        preview_game.users[1].roll = .spy
    }
    
    static func test2() {
        preview_game.answer = "국회의원"
        preview_game.selectedLiars = [2]
        
    }
    
    static func test3() {
        preview_game.answer = "국회의원"
        preview_game.selectedCandidate = preview_game.answer
    }
    
    static func test4() {
        preview_game.selectedCandidate = ""
        preview_game.answer = "환경미화원"
        
    }
    
    
}
