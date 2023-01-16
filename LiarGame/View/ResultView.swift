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
    let navigator: LinkNavigatorType
    var body: some View {
        VStack{
            //시민이 스파이모드에서 스파이를 선택해서 스파이를 맞춤
            if (game.selectedSpy != nil && game.selectedSpy == game.spy) {
                citizenWinningView
            }
            //시민이 스파이를 선택하고 틀리거나 라이어를 선택하고 틀림
            else if (game.selectedSpy != nil && game.selectedSpy != game.spy) || (game.selectedLiar != nil && game.selectedLiar != game.liar) {
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
            
        }
        .navigationBarHidden(true)
    }
    var citizenWinningView: some View {
        VStack(spacing: 30){
            Spacer()
            Text("시민 승리!!")
                .font(.largeTitle.bold())
            
            Text("\(game.selectedSpy! + 1)번은 스파이 입니다.")
                .font(.title)
          
            LottieView(fileName: "Dance")
                .frame(width: 300, height: 300)
            
            Text("잡았지롱")
                .font(.largeTitle.bold())
            Spacer()
            restartButton
        }
    }
    
    var liarWinningView: some View {
        VStack(spacing: 30) {
            Spacer()
            Text(game.gameMode == .spy ? "라이어 스파이 승리!!" : "라이어 승리!!")
                .font(.largeTitle.bold())
            if game.selectedLiar != nil {
                Text("\(game.selectedLiar! + 1)번은 라이어가 아닙니다.")
                    .font(.title)
            }
            else if game.selectedSpy != nil {
                Text("\(game.selectedSpy! + 1)번은 스파이가 아닙니다.")
                    .font(.title)
            }
            
            LottieView(fileName: "Laughing")
                .frame(width: 300, height: 300)
            Text("틀렸지롱")
                .font(.largeTitle.bold())
            Spacer()
            restartButton
        }
    }
    
    var lastChanceSuccess: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("라이어 승리!!")
                .font(.largeTitle.bold())
            Text("정답입니다.")
                .font(.title)
            LottieView(fileName: "Laughing")
                .frame(width: 300, height: 300)
            Text("맞췄지롱")
                .font(.largeTitle.bold())
            Spacer()
            restartButton
            
        }
    }
    
    var lastChanceFailure: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("시민 승리!!")
                .font(.largeTitle.bold())
            Text("정답이 아닙니다.")
                .font(.title)
            LottieView(fileName: "Twerking")
                .frame(width: 300, height: 300)
            Text("응 아니야")
                .font(.largeTitle.bold())
            Spacer()
            restartButton
            
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
                .clipShape(RoundedRectangle(cornerRadius: 20))
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
                test1()
                //스파이 또는 라이어를 선택하고 틀림
                //test2()
                //라스트 찬스에서 라이어가 정답을 맞춤
                //test3()
                //라스트 찬스에서 라이어가 정답을 못맞춤
                //test4()
            }
            .environmentObject(preview_game)
    }
    
    static func test1() {
        preview_game.gameMode = .spy
        preview_game.spy = 3
        preview_game.selectedSpy = preview_game.spy
    }
    
    static func test2() {
        preview_game.answer = "국회의원"
        preview_game.selectedLiar = 2
        preview_game.liar = 3
    }
    
    static func test3() {
        preview_game.answer = "국회의원"
        preview_game.selectedCandidate = preview_game.answer
    }
    
    static func test4() {
        preview_game.selectedCandidate = "대통령"
        preview_game.answer = "환경미화원"
        
    }
    
    
}
