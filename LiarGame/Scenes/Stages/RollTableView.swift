//
//  RollTableView.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/18.
//

import LinkNavigator
import SwiftUI

struct RollTableView: View {
    @EnvironmentObject var game: Game
    
    var sortedUserList: [User] {
        //스파이, 라이어, 시민 순으로 정렬한다.
        return game.users.sorted(by: { user1, user2 in
            switch (user1.roll, user2.roll) {
            case (.spy, _), (.liar, .none): return true
            case (.none, .liar), (_, .spy): return false
            default: return user1.name < user2.name
            }})
    }
                                 
    var body: some View {
        List {
            ForEach(sortedUserList){ user in
                HStack {
                    switch game.namingMode {
                    case .name:
                        Text(user.name)
                            .fontWeight(.semibold)
                            .font(.title2)
                            .padding()
                    case .number:
                        Text("Number %d".localized(with: game.findUserIndex(of: user) + 1))
                            .font(.title2.bold())
                    }
                    
                    Spacer()
                    switch user.roll {
                    case.none:
                        Text(user.roll.localizedName)                            
                            .bold()
                            .myButtonStyle(color: .gray)
                    case .liar:
                        Text(user.roll.localizedName)
                            .bold()
                            .myButtonStyle(color: Color(red: 0, green: 0.5, blue: 0))
                    case .spy:
                        Text(user.roll.localizedName)
                            .bold()
                            .myButtonStyle(color: .red)
                    }                    
                }
            }            
        }
    }
}

struct RollTableView_Previews: PreviewProvider {
    static let preview_game = Game()
    static var previews: some View {
        RollTableView()
            .onAppear {
                preview_game.gameMode = .normal
                preview_game.namingMode = .number
                
                preview_game.users = [
                    User(name: "김민성", roll: .none),
                    User(name: "이시온", roll: .spy),
                    User(name: "박준혁", roll: .liar),
                    User(name: "김주영", roll: .none),
                    User(name: "장재혁", roll: .liar)
                ]
                
                preview_game.answer = "개구리 뒷다리 튀김"
                
            }
            .environmentObject(preview_game)
    }
}
