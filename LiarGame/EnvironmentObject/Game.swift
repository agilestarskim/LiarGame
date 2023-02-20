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
    
    //키워드
    let candidates: [Subjects : [String]] = [
        .object : ["헤드폰", "암막커튼", "고속충전기", "샹들리에", "무선이어폰", "발가락양말", "탈모샴푸", "콧털제거기", "혀 클리너", "무선마우스", "방독면", "스타킹", "가발", "에프킬라", "선글라스", "선크림", "에어컨", "무전기", "손목시계", "비누"],
        .job : ["건축가", "탐정", "세무사", "농부", "백수", "대통령", "국회의원", "청소부", "좀도둑", "클럽MD", "교사", "공무원", "래퍼", "인권운동가", "개그맨", "스턴트맨", "광부", "배우", "아이돌", "어부"],
        .animal : ["기니피그", "알파카", "오랑우탄", "돌고래", "사자", "호랑이", "말", "토끼", "사슴", "침팬지", "박쥐", "양", "기린", "하마", "도마뱀", "개구리", "치타", "표범", "상어", "판다"],
        .country : ["일본", "중국", "미국", "독일", "러시아", "프랑스", "필리핀", "영국", "브라질", "터키", "그리스", "북한", "노르웨이", "이탈리아", "스리랑카", "이스라엘", "호주", "홍콩", "캐나다", "우크라이나"],
        .singer : ["빅뱅", "투애니원", "뉴진스", "노라조", "싸이", "에일리", "이문세", "혁오", "BTS", "나얼", "김범수", "엠씨더맥스", "트와이스", "헤이즈", "딘", "아이유", "기리보이", "케이윌", "마마무", "지코"],
        .location : ["카페", "도서관", "콘서트 장", "화장실", "호텔", "리조트", "영화관", "방탈출카페", "식당", "미용실", "우주", "남극", "탄광", "무인도", "네일샵", "응급실", "묘지", "귀신의 집", "사막", "집"],
        .foods : ["개구리 뒷다리 튀김", "청국장", "김치", "건새우", "불가사리 튀김", "전갈꼬치", "탕후루", "카스테라", "해파리냉채", "케이크", "계란말이", "마라탕", "순대", "곱창전골", "만두전골", "불고기", "깍두기", "피자", "수제비" ,"된장찌개"]
    ]
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
