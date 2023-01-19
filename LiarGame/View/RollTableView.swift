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
    var body: some View {
        List {
            ForEach(game.users.indices, id: \.self){ index in
                HStack {
                    switch game.namingMode {
                    case .name:
                        Text(game.users[index].name)
                            .fontWeight(.semibold)
                            .font(.title2)
                            .padding()
                    case .number:
                        Text("\(index + 1) 번")
                            .font(.title2.bold())
                    }
                    
                    Spacer()
                    switch game.users[index].roll {
                    case.none:
                        Text(game.users[index].roll.rawValue)
                            .tracking(10)
                            .bold()
                            .myButtonStyle(color: .gray)
                    case .liar:
                        Text(game.users[index].roll.rawValue)
                            .bold()
                            .myButtonStyle(color: Color(red: 0, green: 0.5, blue: 0))
                    case .spy:
                        Text(game.users[index].roll.rawValue)
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
