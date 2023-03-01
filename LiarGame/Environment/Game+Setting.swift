//
//  Game+Setting.swift
//  LiarGame
//
//  Created by 김민성 on 2023/03/01.
//

import Foundation

extension Game {
    //유저의 순서를 shift한다.
    //States/ResultView.swift가 disappear하면 trigger된다.
    func rotateSingleLeft(_ users : inout [User]) {
        let first = users.first!
        for i in 0..<users.count - 1 {
            users[i] = users[i + 1]
        }
        users[users.count - 1] = first
    }
    
    //게임 시작 후 변경된 세팅 초기화
    //SettingView onAppear시 trigger
    func resetInGameSetting() {
        self.selectedSpy = nil
        self.selectedLiars = []
        self.selectedCandidate = ""
        self.wrongAnswerForFool = ""
    }
    //이전 게임에서 부여된 역할 초기화
    //SettingView onAppear시 trigger
    func resetRoll() {
        for index in self.users.indices {
            self.users[index].roll = .none
        }
    }
    
    //게임시작 버튼을 누르면 trigger
    func resetGame() {
        setSubject()
        shuffleAnswer()
        setLiar()
        if self.gameMode == .spy {
            setSpy()
        }
    }
    
    //tempSubject와 subject를 나눈 이유:
    //language를 앱 실행 중 바꾸게 되면 subject와 keyword가 매칭되지 않을 수 있다. -> fatalError 발생
    //설정과 게임에서 쓰는 변수를 분리함으로서 예상치못한 에러를 방지할 수 있다.
    //현재 설정된 주제가 키워드에 등록이 되어있는지 검증하는 절차를 추가할 수 있다.
    private func setSubject() {
        if wholeSubjects.contains(self.tempSubject) {
            self.subject = self.tempSubject
        } else {
            switch Locale.current.languageCode {
            case "en":
                self.subject = self.systemSubjects.first ?? "Thing"
            case "ko":
                self.subject = self.systemSubjects.first ?? "직업"
            case "ja":
                //TODO: 일본어 설정
                self.subject = self.systemSubjects.first ?? "직업"
            default:
                self.subject = self.systemSubjects.first ?? "직업"
            }            
        }
    }
    
    //정답 설정
    //TODO: randomElement가 nil일 때 어떻게 조치할 것인가?
    private func shuffleAnswer() {
        //이전과 똑같은 문제 나오는 것 방지
        let newAnswer = wholeKeywords[self.subject, default: []].filter { $0 != self.answer}.randomElement()!
        self.answer = newAnswer
        //바보모드를 위해 정답을 제외한 랜덤 단어 저장
        self.wrongAnswerForFool = wholeKeywords[self.subject, default: []].filter { $0 != self.answer}.randomElement()!
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

