//
//  Card.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/28.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var game: Game
    @State private var showingCard = false
    let user: User
    @Binding var currentIndex: Int
    @Binding var isGameStart: Bool
    
    var body: some View {
        if showingCard {
            card
        } else {
            button
        }
    }
    
    var card: some View {
        VStack(spacing: 20){
            switch user.roll {
            case .none:
                Text(game.answer)
                    .font(.largeTitle.bold())
            case .liar:
                if game.gameMode == .fool {
                    Text(game.wrongAnswerForFool)
                        .font(.largeTitle.bold())
                } else {
                    Text("You are LIAR".localized)
                        .foregroundColor(.red)
                        .font(.largeTitle.bold())
                }
                
            case .spy:
                Text("You are SPY".localized)
                    .foregroundColor(.red)
                    .font(.largeTitle.bold())
                Text(game.answer)
                    .font(.title)
            }
            
            switch game.namingMode {
            case .name:
                Text("-\(user.name)-")
            case .number:
                HStack{                    
                    Text("Your Number is %d".localized(with: game.findUserIndex(of: user) + 1))
                }

                Text("Please remember the number.".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Button {
                currentIndex += 1
                if currentIndex == game.users.count {
                    isGameStart = true
                }
            } label: {
                Text("Confirm".localized)
                    .fitButton(color: Color(red: 0, green: 0.5, blue: 0), vertical: 20, horizontal: 20)
                    .shadow(color: .gray, radius: 5, x: 5, y: 5)
            }
        }
    }
    
    var button: some View {
        VStack{
            switch game.namingMode{
            case .number:
                Button {
                    showingCard = true
                } label: {
                    Text("Check keyword".localized)
                }
                .fitButton(color: Color(red: 0, green: 0, blue: 0.5), vertical: 20, horizontal: 20)
                .shadow(color: .gray, radius: 5, x: 5, y: 5)
            case .name:
                Button {
                    showingCard = true
                } label: {
                    Text("%@'s keyword".localized(with: user.name))
                }
                .fitButton(color: Color(red: 0, green: 0, blue: 0.5), vertical: 20, horizontal: 20)
                .shadow(color: .gray, radius: 5, x: 5, y: 5)
            }
        }
    }
}

