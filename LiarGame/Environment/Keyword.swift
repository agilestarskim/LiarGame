//
//  Keywords.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/20.
//

import Foundation

final class Keyword {
    //생성자를 부를 때 마다 UserDefaults를 읽어들이는 것은 비효율적이기 때문에 싱글톤으로 생성
    static let instance: Keyword = Keyword()
    let userDefaults = UserDefaults.standard
    let systemKeyName = "systemKeywords"
    let customKeyName = "customKeywords"
    private init() {
        //UserDefaults에서 systemKeywords와 customKeywords를 가져와서 set함
        //systemKeyName으로 데이터를 가져와 할당한다. 만약 데이터가 없으면 default 키워드를 할당한다.
        if let systemKeywords = userDefaults.dictionary(forKey: systemKeyName) as? [String: [String]]  {
            self.systemKeywords = systemKeywords
        } else {
            self.systemKeywords = self.defaultKeywords
        }
        
        //customKeyName으로 데이터를 가져와 할당한다. 만약 데이터가 없으면 빈 데이터를 할당한다.
        if let customKeywords = userDefaults.dictionary(forKey: customKeyName) as? [String: [String]] {
            self.customKeywords = customKeywords
        } else {
            self.customKeywords = [:]
        }
    }
    var systemKeywords: [String: [String]]
    
    //keywordDetailView에서 접근
    var systemSubjects: [String] {
        systemKeywords.keys.sorted()
    }
    
    var customKeywords: [String: [String]]
    
    //keywordDetailView에서 접근
    var customSubjects: [String] {
        customKeywords.keys.sorted()
    }
    
    var wholeKeywords: [String: [String]] {
        //키가 중복될 시 systemKeywords를 우선으로 merge
        self.systemKeywords.merging(self.customKeywords){ (current, _) in current }
    }
    
    //
    var wholeSubjects: [String] {
        wholeKeywords.keys.sorted()
    }
    
    func saveSystemKeywords(_ data: [String: [String]]) {
        userDefaults.set(data, forKey: self.systemKeyName)
        systemKeywords = data
    }
    
    func saveCustomKeywords(_ data: [String: [String]]) {
        userDefaults.set(data, forKey: self.customKeyName)
        customKeywords = data
    }
    
    let defaultKeywords: [String : [String]] = [
        "물건" : ["헤드폰", "암막커튼", "고속충전기", "샹들리에", "무선이어폰", "발가락양말", "탈모샴푸", "콧털제거기", "혀 클리너", "무선마우스", "방독면", "스타킹", "가발", "에프킬라", "선글라스", "선크림", "에어컨", "무전기", "손목시계", "비누"],
        "직업" : ["건축가", "탐정", "세무사", "농부", "백수", "대통령", "국회의원", "청소부", "좀도둑", "클럽MD", "교사", "공무원", "래퍼", "인권운동가", "개그맨", "스턴트맨", "광부", "배우", "아이돌", "어부"],
        "동물" : ["기니피그", "알파카", "오랑우탄", "돌고래", "사자", "호랑이", "말", "토끼", "사슴", "침팬지", "박쥐", "양", "기린", "하마", "도마뱀", "개구리", "치타", "표범", "상어", "판다"],
        "국가" : ["일본", "중국", "미국", "독일", "러시아", "프랑스", "필리핀", "영국", "브라질", "터키", "그리스", "북한", "노르웨이", "이탈리아", "스리랑카", "이스라엘", "호주", "홍콩", "캐나다", "우크라이나"],
        "가수" : ["빅뱅", "투애니원", "뉴진스", "노라조", "싸이", "에일리", "이문세", "혁오", "BTS", "나얼", "김범수", "엠씨더맥스", "트와이스", "헤이즈", "딘", "아이유", "기리보이", "케이윌", "마마무", "지코"],
        "장소" : ["카페", "도서관", "콘서트 장", "화장실", "호텔", "리조트", "영화관", "방탈출카페", "식당", "미용실", "우주", "남극", "탄광", "무인도", "네일샵", "응급실", "묘지", "귀신의 집", "사막", "집"],
        "음식" : ["개구리 튀김", "청국장", "김치", "건새우", "불가사리 튀김", "전갈꼬치", "탕후루", "카스테라", "해파리냉채", "케이크", "계란말이", "마라탕", "순대", "곱창전골", "만두전골", "불고기", "깍두기", "피자", "수제비" ,"된장찌개"]
    ]
}