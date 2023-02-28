//
//  Game+Keyword.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/28.
//

import Foundation

extension Game {
    //keywordDetailView에서 접근
    var systemSubjects: [String] {
        systemKeywords.keys.sorted()
    }
    
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
    
    enum SetMode {
        case system, custom, all
    }
    
    func save(key: String, value: [String], for removeMode: SetMode, originalTitle: String = "") {
        //빈 문자열이나 공백을 모두 제거
        let trimmedKeywords = value.filter { !$0.isEmpty }.map { $0.trimmingCharacters(in: .whitespaces) }
        switch removeMode {
        case .system:
            var data = systemKeywords
            data.updateValue(trimmedKeywords, forKey: key)
            //userDefaults에 저장
            UserDefaults.standard.set(data, forKey: Keyword.systemKeyName)
            //실시간 반영
            systemKeywords = data
            return
        case .custom:
            var data = customKeywords
            //제목이 수정되었다면 이전 이름으로 된 데이터를 지운다
            //원본제목이 빈 문자열은 새로 만든 키워드이므로 지울 필요가 없다
            if originalTitle != key && !originalTitle.isEmpty {
                data.removeValue(forKey: originalTitle)
            }
            data.updateValue(trimmedKeywords, forKey: key)
            //userDefaults에 저장
            UserDefaults.standard.set(data, forKey: Keyword.customKeyName)
            //실시간 반영
            customKeywords = data
            return
        case .all:
            return
        }
    }
    
    func remove(key: String) {
        var data = customKeywords
        data.removeValue(forKey: key)
        //userDefault에 반영
        UserDefaults.standard.set(data, forKey: Keyword.customKeyName)
        customKeywords = data
        
        //삭제된 키가 현재 subject이면 없는 키로 게임을 세팅하기 때문에 fatalError를 발생시키므로 다시 세팅해야함
        if subject == key {
            subject = systemSubjects.first ?? "직업"
        }
    }
    
    func reset(for resetMode: SetMode) {
        switch resetMode {
        case .all:
            self.systemKeywords = Keyword.defaultKeywords
            self.customKeywords = [:]
            UserDefaults.standard.removeObject(forKey: Keyword.systemKeyName)
            UserDefaults.standard.removeObject(forKey: Keyword.customKeyName)
        case .system:
            self.systemKeywords = Keyword.defaultKeywords
            UserDefaults.standard.removeObject(forKey: Keyword.systemKeyName)
        case .custom:
            self.customKeywords = [:]
            UserDefaults.standard.removeObject(forKey: Keyword.customKeyName)
        }
        //위의 이유와 같다.
        subject = systemSubjects.first ?? "직업"
    }
}
