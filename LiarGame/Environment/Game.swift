//
//  Game.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//

import SwiftUI

final class Game: ObservableObject {
    //게임 시작 전 세팅 관련 변수
    @Published var subject: String = "직업" //주제
    @Published var gameMode: GameMode = .normal //일반, 스파이, 바보 모드
    @Published var namingMode: NamingMode = .number //번호, 이름 모드
    @Published var users: [User] = [User(), User(), User()] //User(name,liar,spy)
    @Published var numberOfLiars = 1 //라이어 수
    @Published var time: Int = 2 //게임시간(분)
    @Published var soundEffect = true
    
    //게임 시작 후 게임정보 관련 변수
    var answer: String = "" //keywords에서 subject에 연관된 단어를 무작위로 찾음.
    var wrongAnswerForFool: String = "" //바보모드를 위해 answer를 제외한 단어
    @Published var selectedLiars: Set<Int> = [] //게임 중 지목당한 라이어
    @Published var selectedSpy: Int? = nil //게임 중 지목당한 스파이
    var selectedCandidate: String = "" //게임 중 라이어가 선택한 정답 후보
    
    @Published var keyword: Keyword = Keyword()
}

enum GameMode: String, Equatable, CaseIterable {
    case normal = "일반"
    case spy = "스파이"
    case fool = "바보"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

enum NamingMode: String, Equatable, CaseIterable {
    case number = "자동 번호 부여"
    case name = "이름 직접 지정"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
