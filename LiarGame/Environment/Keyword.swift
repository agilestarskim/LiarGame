//
//  Keywords.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/20.
//

import Foundation

final class Keyword {
    private let userDefaults = UserDefaults.standard
    private let systemKeyName = "systemKeywords"
    private let customKeyName = "customKeywords"
    init() {
        //UserDefaults에서 systemKeywords와 customKeywords를 가져와서 set함
        //systemKeyName으로 데이터를 가져와 할당한다. 만약 데이터가 없으면 default 키워드를 할당한다.
        if let systemKeywords = userDefaults.dictionary(forKey: systemKeyName) as? [String: [String]]  {
            self.systemKeywords = systemKeywords
        } else {
            self.systemKeywords = Keyword.defaultKeywords
            
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
    
    //대부분 뷰에서 접근
    var wholeSubjects: [String] {
        wholeKeywords.keys.sorted()
    }
    
    
    
    enum RemoveMode {
        case system, custom, all
    }
    
    func save(key: String, value: [String], for removeMode: RemoveMode, originalTitle: String = "") {
        //빈 문자열이나 공백을 모두 제거
        let trimmedKeywords = value.filter { !$0.isEmpty }.map { $0.trimmingCharacters(in: .whitespaces) }
        switch removeMode {
        case .system:
            var data = systemKeywords
            data.updateValue(trimmedKeywords, forKey: key)
            userDefaults.set(data, forKey: systemKeyName)
            return
        case .custom:
            var data = customKeywords
            //제목이 수정되었다면 이전 이름으로 된 데이터를 지운다
            //원본제목이 빈 문자열은 새로 만든 키워드이므로 지울 필요가 없다
            if originalTitle != key && !originalTitle.isEmpty {
                data.removeValue(forKey: originalTitle)
            }
            data.updateValue(trimmedKeywords, forKey: key)
            userDefaults.set(data, forKey: customKeyName)
            return
        case .all:
            return
        }
    }
    
    func remove(key: String) {
        var data = customKeywords
        data.removeValue(forKey: key)
        userDefaults.set(data, forKey: customKeyName)
    }
    
    func removeFromUserDefaults(for removeMode: RemoveMode) {
        switch removeMode {
        case .all:
            userDefaults.removeObject(forKey: systemKeyName)
            userDefaults.removeObject(forKey: customKeyName)
        case .system:
            userDefaults.removeObject(forKey: systemKeyName)
        case .custom:
            userDefaults.removeObject(forKey: customKeyName)
        }
    }
    
    static let defaultEnglishKeywords: [String : [String]] = [
        "Thing" : ["Headphones", "iPhone", "Hoodie", "Dynamite", "Chandelier", "Deodorant", "Jeans", "Car", "Toothbrush", "Air conditioner", "gas mask", "Stockings", "Baseball bat", "Brick", "Sunglasses", "Suncream", "Fan", "Cap", "Nuclear bomb", "Lamp"],
        "Job" : ["Architect", "Detective", "Tax Accountant", "Farmer", "Clerk", "President", "Singer", "Cleaner", "Thief", "Bodyguard", "Teacher", "Miner", "Rapper", "Human rights activist", "Comedian", "Football player", "Pianist", "Soldier", "Police officer", "Fisherman"],
        "Animal" : ["Chimpanzee", "Alpaca", "Orangutan", "Dolphin", "Giraffe", "Elephant", "Hedgehog", "Monkey", "Opossum", "Sperm Whale", "Moose", "Shark", "Falcon", "Dove", "Chicken", "Python", "Lizard", "Salmon", "Dogfish", "Mosquito"],
        "Country" : ["Japan", "China", "USA", "Germany", "Russia", "France", "India", "England", "Brazil", "Korea", "Canada", "Mexico", "Spain", "Italy", "Israel", "Pakistan", "Hong Kong", "Netherlands", "Ukraine", "Uruguay"],
        "Singer" : ["Michael Jackson", "Mariah Carey", "Beatles", "Madonna", "Beyoncé", "Eminem", "Kanye West", "Drake", "BTS", "Taylor Swift", "Post Malone", "Marron 5", "Justin Bieber", "Ed Sheeran", "The Weeknd", "Harry Styles", "Bruno Mars", "ADELE", "Tupac", "50 Cent"],
        "Place" : ["Café", "Library", "Concert hall", "Bathroom", "Hotel", "Theater", "School", "Prison", "Restaurant", "Hair salon", "Space", "Antarctica", "Coal mine", "Uninhabited island", "Nail salon", " Desert", "Cemetry", "House", "Garage", "Gym"],
        "Food" : ["Burgers", "Apple Pie", "French Fries", "Hot Dogs", "Pizza", "Durian", "Ants egg soup", "Beef tongue", "Chicken feet", "Frogs legs", "Oysters", "Cornbread", "Macaroni", "Peanut Butter", "Buffalo Wings", "Barbecue", "Cheesecake", "Fried scorpion", "Fried locusts" ,"Corn soup"]
    ]
    
    static let defaultKeywords: [String : [String]] = [
        "물건" : ["헤드폰", "암막커튼", "고속충전기", "샹들리에", "무선이어폰", "발가락양말", "탈모샴푸", "콧털제거기", "혀 클리너", "무선마우스", "방독면", "스타킹", "가발", "에프킬라", "선글라스", "선크림", "에어컨", "무전기", "손목시계", "비누"],
        "직업" : ["건축가", "탐정", "세무사", "농부", "백수", "대통령", "국회의원", "청소부", "좀도둑", "클럽MD", "교사", "공무원", "래퍼", "인권운동가", "개그맨", "스턴트맨", "광부", "배우", "아이돌", "어부"],
        "동물" : ["기니피그", "알파카", "오랑우탄", "돌고래", "사자", "호랑이", "말", "토끼", "사슴", "침팬지", "박쥐", "양", "기린", "하마", "도마뱀", "개구리", "치타", "표범", "상어", "판다"],
        "국가" : ["일본", "중국", "미국", "독일", "러시아", "프랑스", "필리핀", "영국", "브라질", "터키", "그리스", "북한", "노르웨이", "이탈리아", "스리랑카", "이스라엘", "호주", "홍콩", "캐나다", "우크라이나"],
        "가수" : ["빅뱅", "투애니원", "뉴진스", "노라조", "싸이", "에일리", "이문세", "혁오", "BTS", "나얼", "김범수", "엠씨더맥스", "트와이스", "헤이즈", "딘", "아이유", "기리보이", "케이윌", "마마무", "지코"],
        "장소" : ["카페", "도서관", "콘서트 장", "화장실", "호텔", "리조트", "영화관", "방탈출카페", "식당", "미용실", "우주", "남극", "탄광", "무인도", "네일샵", "응급실", "묘지", "귀신의 집", "사막", "집"],
        "음식" : ["개구리 튀김", "청국장", "김치", "건새우", "불가사리 튀김", "전갈꼬치", "탕후루", "카스테라", "해파리냉채", "케이크", "계란말이", "마라탕", "순대", "곱창전골", "만두전골", "불고기", "깍두기", "피자", "수제비" ,"된장찌개"]
    ]
    
    static let defaultJapaneseKeywords: [String : [String]] = [
        "물건" : ["헤드폰", "암막커튼", "고속충전기", "샹들리에", "무선이어폰", "발가락양말", "탈모샴푸", "콧털제거기", "혀 클리너", "무선마우스", "방독면", "스타킹", "가발", "에프킬라", "선글라스", "선크림", "에어컨", "무전기", "손목시계", "비누"],
        "직업" : ["건축가", "탐정", "세무사", "농부", "백수", "대통령", "국회의원", "청소부", "좀도둑", "클럽MD", "교사", "공무원", "래퍼", "인권운동가", "개그맨", "스턴트맨", "광부", "배우", "아이돌", "어부"],
        "동물" : ["기니피그", "알파카", "오랑우탄", "돌고래", "사자", "호랑이", "말", "토끼", "사슴", "침팬지", "박쥐", "양", "기린", "하마", "도마뱀", "개구리", "치타", "표범", "상어", "판다"],
        "국가" : ["일본", "중국", "미국", "독일", "러시아", "프랑스", "필리핀", "영국", "브라질", "터키", "그리스", "북한", "노르웨이", "이탈리아", "스리랑카", "이스라엘", "호주", "홍콩", "캐나다", "우크라이나"],
        "가수" : ["빅뱅", "투애니원", "뉴진스", "노라조", "싸이", "에일리", "이문세", "혁오", "BTS", "나얼", "김범수", "엠씨더맥스", "트와이스", "헤이즈", "딘", "아이유", "기리보이", "케이윌", "마마무", "지코"],
        "장소" : ["카페", "도서관", "콘서트 장", "화장실", "호텔", "리조트", "영화관", "방탈출카페", "식당", "미용실", "우주", "남극", "탄광", "무인도", "네일샵", "응급실", "묘지", "귀신의 집", "사막", "집"],
        "음식" : ["개구리 튀김", "청국장", "김치", "건새우", "불가사리 튀김", "전갈꼬치", "탕후루", "카스테라", "해파리냉채", "케이크", "계란말이", "마라탕", "순대", "곱창전골", "만두전골", "불고기", "깍두기", "피자", "수제비" ,"된장찌개"]
    ]
}
