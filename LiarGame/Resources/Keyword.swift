//
//  Keywords.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/20.
//

import Foundation

final class Keyword {
    static let systemKeyNameForEN = "systemKeywordsForEN"
    static let systemKeyNameForKO = "systemKeywordsForKO"
    static let systemKeyNameForJA = "systemKeywordsForJA"
    static let customKeyName = "customKeywords"
    
    static func getDefaultKeywords() -> [String: [String]]{
        switch Locale.current.languageCode {
        case "en":
            return defaultEnglishKeywords
        case "ko":
            return defaultKoreanKeywords
        case "ja":
            return defaultJapaneseKeywords
        default:
            return defaultKoreanKeywords
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
    
    static let defaultKoreanKeywords: [String : [String]] = [
        "물건" : ["헤드폰", "암막커튼", "고속충전기", "샹들리에", "무선이어폰", "발가락양말", "탈모샴푸", "콧털제거기", "혀 클리너", "무선마우스", "방독면", "스타킹", "가발", "에프킬라", "선글라스", "선크림", "에어컨", "무전기", "손목시계", "비누"],
        "직업" : ["건축가", "탐정", "세무사", "농부", "백수", "대통령", "국회의원", "청소부", "좀도둑", "클럽MD", "교사", "공무원", "래퍼", "인권운동가", "개그맨", "스턴트맨", "광부", "배우", "아이돌", "어부"],
        "동물" : ["기니피그", "알파카", "오랑우탄", "돌고래", "사자", "호랑이", "말", "토끼", "사슴", "침팬지", "박쥐", "양", "기린", "하마", "도마뱀", "개구리", "치타", "표범", "상어", "판다"],
        "국가" : ["일본", "중국", "미국", "독일", "러시아", "프랑스", "필리핀", "영국", "브라질", "터키", "그리스", "북한", "노르웨이", "이탈리아", "스리랑카", "이스라엘", "호주", "홍콩", "캐나다", "우크라이나"],
        "가수" : ["빅뱅", "투애니원", "뉴진스", "노라조", "싸이", "에일리", "이문세", "혁오", "BTS", "나얼", "김범수", "엠씨더맥스", "트와이스", "헤이즈", "딘", "아이유", "기리보이", "케이윌", "마마무", "지코"],
        "장소" : ["카페", "도서관", "콘서트 장", "화장실", "호텔", "리조트", "영화관", "방탈출카페", "식당", "미용실", "우주", "남극", "탄광", "무인도", "네일샵", "응급실", "묘지", "귀신의 집", "사막", "집"],
        "음식" : ["개구리 튀김", "청국장", "김치", "건새우", "불가사리 튀김", "전갈꼬치", "탕후루", "카스테라", "해파리냉채", "케이크", "계란말이", "마라탕", "순대", "곱창전골", "만두전골", "불고기", "깍두기", "피자", "수제비" ,"된장찌개"]
    ]
    
    static let defaultJapaneseKeywords: [String : [String]] = [
        "品物" : ["ヘッドホン", "カーテン", "充電器", "シャンデリア", "イヤホン", "靴下", "シャンプー", "鼻毛カッター", "マスク", "マウス", "=防毒面", "けん玉", "かつら", "むしよけ", "サングラス", "日焼け止め", "エアコン", "無電機", "腕時計", "石鹸"],
        "職業" : ["建築家", "探偵", "税理士", "農夫", "百獣", "公主", "議員", "清掃員", "泥棒", "サッカー選手", "家庭教師", "国家公務員", "ラッパー", "人権活動家", "コメディアン", "スタントマン", "鉱夫", "俳優", "アイドル", "漁師"],
        "動物" : ["ギニー・ピッグ", "アルパカ", "テナガザル", "イルカ", " ライオン", "トラ", "馬", "ウサギ", "シカ", "チンパンジー", "蝙蝠", "羊", "麒麟", "河馬", "蜥蜴", "蛙", "チーター", "ヒョウ", "さめ", "パンダ"],
        "国家" : ["日本", "中国", "米国", "獨逸", "ロシア", "フランス", "フィリピン", "英國", "ブラジル", "トルコ", "ギリシャ", "北韓", "ノルウェー", "イタリア", "スリランカ", "イスラエル", "濠洲", "ホンコン", "カナダ", "ウクライナ"],
        "芸能人" : ["DAIGO", "二宮和也", "タモリ", "マツコデラックス", "北川景子", "広瀬すず", "橋本環奈", "宮野真守", "石原さとみ", "有村架純", "新垣結衣", "佐藤健", "菅田将暉", "小栗旬", "坂口健太郎", "斎藤工", "神木隆之介", "高橋一生", "山下智久", "平野紫耀"],
        "場所" : ["お台場", "美術館", "ヘアサロン", "ネールサロン", "トイレ", "病院", "ドラッグストア", "古着屋", "パン屋", "食堂", "カフェ", "ライブハウス", "銀座", "原宿", "渋谷", "百貨店", "お化け屋敷", "水族館", "居酒屋", "図書館"],
        "食べ物" : ["牛丼", "団子", "プリン", "サンドウィッチ", "おにぎり", "キチン", "おでん", "せんべい", "パンケーキ", "卵焼き", "モツ鍋", "ケーキ", "味噌汁", "ピザ", "エビフライ", "天丼", "天ぷら", "カレー", "チョコレート" ,"アイスクリーム"]
    ]
}
