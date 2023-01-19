//
//  ChoiceView.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/01.
//

import LinkNavigator
import SwiftUI
enum SpyOrLiar: String, CaseIterable, Equatable {
    case liar = "라이어 찾기"
    case spy = "스파이 찾기"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
struct ChoiceView: View {
    @EnvironmentObject var game: Game
    @State private var spyOrLiar: SpyOrLiar = .liar
    let navigator: LinkNavigatorType
    var body: some View {
        ScrollView {
            headerView
            stateView
            pickerView
            choiceView
        }
        .navigationBarHidden(true)
    }
    
    var headerView: some View {
        VStack{
            switch game.gameMode {
            case .normal, .fool:
                Text("라이어를 맞춰주세요")
                    .font(.largeTitle.bold())
            case .spy:
                Text("라이어 또는 스파이를 맞춰주세요")
                    .font(.title2.bold())
            }
        }
        .padding(.top, 30)
    }
    
    var stateView: some View {
        HStack {
            Text("라이어: \(game.numberOfLiars)명")
            if game.gameMode == .spy {
                Text("스파이: 1명")
            }
        }
        .font(.title2)
        .padding(.top)
    }
    
    var pickerView: some View {
        VStack{
            if game.gameMode == .spy {
                Picker("라이어 또는 스파이", selection: $spyOrLiar) {
                    ForEach(SpyOrLiar.allCases, id: \.self) { value in
                        Text(value.localizedName)
                    }
                }
                .disabled(game.selectedLiars.count > 0)
                .pickerStyle(.segmented)
            }else{
                EmptyView()
            }
        }
        .padding()
    }

    var choiceView: some View {
        VStack {
            ForEach(game.users.indices, id: \.self) { index in
                Button {
                    switch spyOrLiar {
                    case .liar:
                        onTapLiarButton(index: index)
                    case .spy:
                        onTapSpyButton(index: index)
                    }
                } label: {
                    HStack {
                        Text(game.namingMode == .number ? "\(index + 1)번" : game.users[index].name)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding()
                            .background(game.selectedLiars.contains(index) ? .gray :
                                            spyOrLiar == .liar ? .blue : .red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                    }
                }
                .disabled(game.selectedLiars.contains(index))
            }
        }
    }
    
    private func onTapLiarButton(index: Int) {
        game.selectedLiars.insert(index)
        guard game.selectedLiars.count == game.numberOfLiars else { return }
        if game.selectedLiars == game.getLiarsIndexes {
            navigator.next(paths: ["lastChance"], items: [:], isAnimated: true)
        } else {
            navigator.next(paths: ["result"], items: [:], isAnimated: true)
        }
    }
    
    private func onTapSpyButton(index: Int) {
        game.selectedSpy = index
        navigator.next(paths: ["result"], items: [:], isAnimated: true)
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
                preview_game.gameMode = .spy
                preview_game.numberOfLiars = 2                
                preview_game.users[0].roll = .liar
                preview_game.users[1].roll = .spy
                preview_game.users[2].roll = .liar
                
                preview_game.users[0].name = "김민성"
                preview_game.users[1].name = "이시온"
                preview_game.users[2].name = "박준혁"
                preview_game.namingMode = .name
                preview_game.answer = "국회의원"
            }
            .environmentObject(preview_game)
    }
}
