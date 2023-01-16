//
//  Game.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//

import SwiftUI

final class Game: ObservableObject {
    @Published var subject: Subjects = .job
    @Published var gameMode: GameMode = .normal
    @Published var namingMode: NamingMode = .number
    @Published var users: [User] = [User](repeating: User(), count: 3)    
    @Published var numberOfLiars = 1
    @Published var liarsMode: LiarsMode = .all
    @Published var time: Int = 2
    
    
    //deprecated
    @Published var numberOfMembers: Int = 3
    
    var answer: String = ""
    var wrongAnswerForFool: String = ""
    var liar: Int = 0
    var spy: Int? = nil
    var selectedLiar: Int? = nil
    var selectedSpy: Int? = nil
    var selectedCandidate: String = ""
    
    let candidates: [Subjects : [String]] = [
        .object : ["헤드폰", "암막커튼", "고속충전기", "샹들리에", "무선이어폰", "발가락양말", "탈모샴푸", "콧털제거기", "혀 클리너", "무선마우스", "방독면", "스타킹", "가발", "에프킬라", "선글라스", "선크림", "에어컨", "무전기", "손목시계", "비누"],
        .job : ["건축가", "탐정", "세무사", "농부", "백수", "대통령", "국회의원", "청소부", "좀도둑", "클럽MD", "교사", "공무원", "래퍼", "인권운동가", "개그맨", "스턴트맨", "광부", "배우", "아이돌", "어부"],
        .animal : ["기니피그", "알파카", "오랑우탄", "돌고래", "사자", "호랑이", "말", "토끼", "사슴", "침팬지", "박쥐", "양", "기린", "하마", "도마뱀", "개구리", "치타", "표범", "상어", "판다"],
        .country : ["일본", "중국", "미국", "독일", "러시아", "프랑스", "필리핀", "영국", "브라질", "터키", "그리스", "북한", "노르웨이", "이탈리아", "스리랑카", "이스라엘", "호주", "홍콩", "캐나다", "우크라이나"],
        .singer : ["빅뱅", "투애니원", "양다일", "노라조", "싸이", "에일리", "이문세", "혁오", "윤도현", "나얼", "김범수", "엠씨더맥스", "트와아스", "헤이즈", "딘", "아이유", "기리보이", "케이윌", "마마무", "이승기"],
        .location : ["카페", "도서관", "콘서트 장", "화장실", "모텔", "리조트", "영화관", "방탈출카페", "식당", "미용실", "우주", "남극", "탄광", "무인도", "네일샵", "응급실", "묘지", "귀신의 집", "사막", "집"],
        .foods : ["개구리 뒷다리 튀김", "청국장", "김치", "건새우", "불가사리 튀김", "전갈꼬치", "탕후루", "카스테라", "해파리냉채", "케이크", "계란말이", "마라탕", "순대", "곱창전골", "만두전골", "불고기", "깍두기", "피자", "수제비" ,"된장찌개"]
    ]
    func addUser() {
        guard users.count < 20 else { return }
        self.users.append(User())
    }
    
    func removeUser(index: Int) {
        guard users.count > 3 else { return }
        self.users.remove(at: index)
    }
    
    func removeUserLast() {
        guard users.count > 3 else { return }
        self.users.removeLast()
    }
    
    func resetGame() {
        resetItem()
        shuffleAnswer()
        shuffleLiar()
        if self.gameMode == .spy {
            shuffleSpy()
        }
    }
    func resetItem() {
        self.selectedSpy = nil
        self.selectedLiar = nil
        self.selectedCandidate = ""
        self.wrongAnswerForFool = ""
        self.spy = nil
    }
    
    func shuffleAnswer() {
        //이전과 똑같은 문제 나오는 것 방지
        var newAnswer = (self.candidates[self.subject]?.randomElement())!
        if self.answer != "" && newAnswer == self.answer {
            while(newAnswer == self.answer) {
                newAnswer = (self.candidates[self.subject]?.randomElement())!
            }
        }
        self.answer = newAnswer
        self.wrongAnswerForFool = (self.candidates[self.subject]?.randomElement())!
        while(self.answer == self.wrongAnswerForFool) {
            self.wrongAnswerForFool = (self.candidates[self.subject]?.randomElement())!
        }
    }
    
    func shuffleLiar() {
        self.liar = Int.random(in: 0..<self.numberOfMembers)
    }
    
    func shuffleSpy() {
        self.spy = Int.random(in: 0..<self.numberOfMembers)
        while(self.spy == self.liar){
            self.spy = Int.random(in: 0..<self.numberOfMembers)
        }        
    }
}
//Memeber Model
struct User {
    var name: String = ""
    var liar: Bool = false
    var spy: Bool = false
}

//enums
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

enum LiarsMode: String, Equatable, CaseIterable {
    case one = "한 명 잡기"
    case all = "모두 잡기"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

enum Subjects: String, Equatable, CaseIterable {
    case object = "물건"
    case job = "직업"
    case animal = "동물"
    case country = "국가"
    case singer = "가수"
    case location = "장소"
    case foods = "음식"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}


