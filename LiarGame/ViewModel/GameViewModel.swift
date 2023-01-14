//
//  GameViewModel.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//

import Foundation

extension GameView {
    class ViewModel: ObservableObject {
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @Published var remainingTime: Int = 10
        @Published var showingCard = false
        @Published var isGameStart = false
        @Published var isGameEnd = false
        @Published var index = 0
    }
}
