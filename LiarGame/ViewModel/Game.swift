//
//  Game.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//

import SwiftUI

final class Game: ObservableObject {
    //게임 시작 전 세팅 관련 변수
    @Published var subject: Subjects = .job //주제
    @Published var gameMode: GameMode = .normal //일반, 스파이, 바보 모드
    @Published var namingMode: NamingMode = .number //번호, 이름 모드
    @Published var users: [User] = [User(), User(), User()] //User(name,liar,spy)
    @Published var numberOfLiars = 1 //라이어 수
    @Published var time: Int = 2 //게임시간(분)
    @Published var soundEffect = true
    
    //게임 시작 후 게임정보 관련 변수
    var answer: String = "" //candidates에서 subject에 연관된 단어를 무작위로 찾음.
    var wrongAnswerForFool: String = "" //바보모드를 위해 answer를 제외한 단어
    @Published var selectedLiars: Set<Int> = [] //게임 중 지목당한 라이어
    @Published var selectedSpy: Int? = nil //게임 중 지목당한 스파이
    var selectedCandidate: String = "" //게임 중 라이어가 선택한 정답 후보
    
    var getLiarsIndexes: Set<Int> {
        Set(self.users.enumerated().filter { $0.element.roll == .liar }.map { $0.offset })
    }
    var getSpyIndex: Int {
        return self.users.firstIndex(where: { $0.roll == .spy }) ?? -1        
    }
    
    var getOneSelectedLiar: Int {
        guard self.selectedLiars.count == 1 else { return 0 }
        guard let liar = self.selectedLiars.first else { return 0 }
        return liar
    }

    
    let candidates: [Subjects : [String]] = [
        .object : ["헤드폰", "암막커튼", "고속충전기", "샹들리에", "무선이어폰", "발가락양말", "탈모샴푸", "콧털제거기", "혀 클리너", "무선마우스", "방독면", "스타킹", "가발", "에프킬라", "선글라스", "선크림", "에어컨", "무전기", "손목시계", "비누"],
        .job : ["건축가", "탐정", "세무사", "농부", "백수", "대통령", "국회의원", "청소부", "좀도둑", "클럽MD", "교사", "공무원", "래퍼", "인권운동가", "개그맨", "스턴트맨", "광부", "배우", "아이돌", "어부"],
        .animal : ["기니피그", "알파카", "오랑우탄", "돌고래", "사자", "호랑이", "말", "토끼", "사슴", "침팬지", "박쥐", "양", "기린", "하마", "도마뱀", "개구리", "치타", "표범", "상어", "판다"],
        .country : ["일본", "중국", "미국", "독일", "러시아", "프랑스", "필리핀", "영국", "브라질", "터키", "그리스", "북한", "노르웨이", "이탈리아", "스리랑카", "이스라엘", "호주", "홍콩", "캐나다", "우크라이나"],
        .singer : ["빅뱅", "투애니원", "뉴진스", "노라조", "싸이", "에일리", "이문세", "혁오", "BTS", "나얼", "김범수", "엠씨더맥스", "트와아스", "헤이즈", "딘", "아이유", "기리보이", "케이윌", "마마무", "지코"],
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
    
    func findUserIndex(of user: User) -> Int {
        return self.users.firstIndex(of: user) ?? 0
    }
    
    func rotateSingleLeft(_ users : inout [User]) {
        let first = users.first!
        for i in 0..<users.count - 1 {
            users[i] = users[i + 1]
        }
        users[users.count - 1] = first
    }
    
    func resetGame() {
        resetInGameSetting()
        resetRoll()
        shuffleAnswer()
        setLiar()
        if self.gameMode == .spy {
            setSpy()
        }
//        test
//        self.users.forEach { user in
//            print(user.name, user.roll)
//        }
    }
    //게임 시작 후 변경된 세팅 초기화
    private func resetInGameSetting() {
        self.selectedSpy = nil
        self.selectedLiars = []
        self.selectedCandidate = ""
        self.wrongAnswerForFool = ""
    }
    //이전 게임에서 부여된 역할 초기화
    private func resetRoll() {
        for index in self.users.indices {
            self.users[index].roll = .none
        }
    }
    //정답 설정
    private func shuffleAnswer() {
        //이전과 똑같은 문제 나오는 것 방지
        let newAnswer = self.candidates[self.subject]!.filter { $0 != self.answer}.randomElement()!
        self.answer = newAnswer
        //바보모드를 위해 정답을 제외한 랜덤 단어 저장
        self.wrongAnswerForFool = self.candidates[self.subject]!.filter { $0 != self.answer}.randomElement()!
    }
    //라이어 설정
    private func setLiar() {
        let numOfUsers = self.users.count
        let numOfLiars = self.numberOfLiars
        //겹치지 않게 랜덤한 번호를 저장하는 알고리즘
        var liars = Set<Int>()
        while liars.count < numOfLiars {
            liars.insert(Int.random(in: 0...(numOfUsers - 1)))
        }
        //example: numOfUsers 6, numOfLiars 2, liars = [1,5]
        //example: numOfUsers 5, numOfLiars 1, liars = [3]
        liars.forEach { index in
            self.users[index].roll = .liar
        }
        
    }
    //스파이 설정
    private func setSpy() {
        //users에서 라이어가 아닌 유저를 뽑아 그 중 랜덤한 유저를 뽑고 인덱스를 찾아 해당 인덱스의 유저를 스파이로 지정한다.
        guard let user = self.users.filter({ $0.roll != .liar }).randomElement() else { return }
        guard let index = self.users.firstIndex(of: user) else { return }
        self.users[index].roll = .spy
    }
    

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
