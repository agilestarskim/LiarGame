//
//  Game.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//

import SwiftUI

final class Game: ObservableObject {
    //게임 시작 전 세팅 관련 변수
    @Published var tempSubject: String //설정에서만 사용할 주제, 게임시작 후 해당 값을 subject로 보냄
    @Published var gameMode: GameMode = .normal //일반, 스파이, 바보 모드
    @Published var namingMode: NamingMode = .number //번호, 이름 모드
    @Published var users: [User] = [User(), User(), User()] //User(name,liar,spy)
    @Published var numberOfLiars = 1 //라이어 수
    @Published var time: Int = 2 //게임시간(분)
    @Published var soundEffect = true
    
    //게임 시작 후 게임정보 관련 변수
    var subject: String //게임에서 사용하는 주제, 게임시작 후 값 세팅 됨.
    var answer: String = "" //keywords에서 subject에 연관된 단어를 무작위로 찾음.
    var wrongAnswerForFool: String = "" //바보모드를 위해 answer를 제외한 단어
    @Published var selectedLiars: Set<Int> = [] //게임 중 지목당한 라이어
    @Published var selectedSpy: Int? = nil //게임 중 지목당한 스파이
    var selectedCandidate: String = "" //게임 중 라이어가 선택한 정답 후보
    
    @Published var systemKeywords: [String: [String]]
    @Published var customKeywords: [String: [String]]
    
    init() {
        //UserDefaults에서 systemKeywords와 customKeywords를 가져와서 set함
        //systemKeyName으로 데이터를 가져와 할당한다. 만약 데이터가 없으면 default 키워드를 할당한다.
        var systemKeywords: [String: [String]]
        switch Locale.current.languageCode {
        case "en":
            systemKeywords = UserDefaults.standard.dictionary(forKey: Keyword.systemKeyNameForEN) as? [String: [String]] ?? Keyword.defaultEnglishKeywords
        case "ko":
            systemKeywords = UserDefaults.standard.dictionary(forKey: Keyword.systemKeyNameForKO) as? [String: [String]] ?? Keyword.defaultKoreanKeywords
        case "ja":
            systemKeywords = UserDefaults.standard.dictionary(forKey: Keyword.systemKeyNameForJA) as? [String: [String]] ?? Keyword.defaultJapaneseKeywords
        default:
            systemKeywords = UserDefaults.standard.dictionary(forKey: Keyword.systemKeyNameForKO) as? [String: [String]] ?? Keyword.defaultKoreanKeywords
        }
        self.systemKeywords = systemKeywords
        //customKeyName으로 데이터를 가져와 할당한다. 만약 데이터가 없으면 빈 데이터를 할당한다.
        self.customKeywords = UserDefaults.standard.dictionary(forKey: Keyword.customKeyName) as? [String: [String]] ?? [:]
        
        //게임에 사용될 subject, 설정을 위한 tempSubject의 초기값은 시스템키워드의 첫번 째 키로 설정
        self.tempSubject = systemKeywords.keys.first ?? "직업"
        self.subject = systemKeywords.keys.first ?? "직업"
    }
}

enum GameMode: String, Equatable, CaseIterable {
    case normal = "Normal"
    case spy = "Spy"
    case fool = "Fool"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

enum NamingMode: String, Equatable, CaseIterable {
    case number = "Play with Number"
    case name = "Play with Name"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
