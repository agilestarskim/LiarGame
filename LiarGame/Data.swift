//
//  Data.swift
//  LiarGame
//
//  Created by 김민성 on 2022/07/01.
//

import Foundation

class Data {
    let subject: String
    let members: Int
    let mode: Mode
    let dict: [String : [String]] = [
        "물건" : ["헤드폰", "암막커튼", "고속충전기", "샹들리에", "무선이어폰", "발가락양말", "탈모샴푸", "콧털제거기", "혀 클리너", "무선마우스", "방독면", "스타킹", "가발", "에프킬라", "선글라스", "선크림", "에어컨", "무전기", "손목시계", "비누"],
        "직업" : ["건축가", "탐정", "세무사", "농부", "백수", "대통령", "국회의원", "청소부", "좀도둑", "클럽MD", "교사", "공무원", "래퍼", "인권운동가", "개그맨", "스턴트맨", "광부", "배우", "아이돌", "어부"],
        "동물" : ["기니피그", "알파카", "오랑우탄", "돌고래", "사자", "호랑이", "말", "토끼", "사슴", "침팬지", "박쥐", "양", "기린", "하마", "도마뱀", "개구리", "치타", "표범", "상어", "판다"],
        "국가" : ["일본", "중국", "미국", "독일", "러시아", "프랑스", "필리핀", "영국", "브라질", "터키", "그리스", "북한", "노르웨이", "이탈리아", "스리랑카", "이스라엘", "호주", "홍콩", "캐나다", "우크라이나"],
        "가수" : ["빅뱅", "투애니원", "양다일", "노라조", "싸이", "에일리", "이문세", "혁오", "윤도현", "나얼", "김범수", "엠씨더맥스", "트와아스", "헤이즈", "딘", "아이유", "기리보이", "케이윌", "마마무", "이승기"],
        "장소" : ["카페", "도서관", "콘서트 장", "화장실", "모텔", "리조트", "영화관", "방탈출카페", "식당", "미용실", "우주", "남극", "탄광", "무인도", "네일샵", "응급실", "묘지", "귀신의 집", "사막", "집"],
        "음식" : ["개구리 뒷다리 튀김", "청국장", "김치", "건새우", "불가사리 튀김", "전갈꼬치", "탕후루", "카스테라", "해파리냉채", "케이크", "계란말이", "마라탕", "순대", "곱창전골", "만두전골", "불고기", "깍두기", "피자", "수제비" ,"된장찌개"]
    ]
    init(subject: String, members: Int, mode: Mode){
        self.subject = subject
        self.members = members
        self.mode = mode
    }
    
    var list: [String] {
        switch mode {
        case .normal:
            var array: [String] = [String](repeating: dict[subject, default: []].randomElement() ?? "에러", count: members - 1)
            array.append("라이어 당첨")
            return array.shuffled()
        case .spy:
            let answer = dict[subject, default: []].randomElement() ?? "에러"
            var array: [String] = [String](repeating: answer, count: members - 2)
            array.append("라이어 당첨")
            array.append("제시어: \(answer)\n스파이 당첨")
            return  array.shuffled()
        case .fool:
            var data = dict[subject, default: []]
            let answer = dict[subject, default: []].randomElement() ?? "에러"
            data.remove(at: data.firstIndex(of: answer) ?? 0)
            let fool = data.randomElement() ?? "에러"
            var array: [String] = [String](repeating: answer, count: members - 1)
            array.append(fool)
            return array.shuffled()
            
        }
    }
}
