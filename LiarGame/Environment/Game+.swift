//
//  Game+.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/20.
//

import Foundation

extension Game {
    
    
    
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
    
    //유저의 순서를 shift한다.
    //States/ResultView.swift에서 다시하기 버튼을 클릭하면 trigger된다.
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
        let newAnswer = self.keyword.wholeKeywords[self.subject, default: []].filter { $0 != self.answer}.randomElement()!
        self.answer = newAnswer
        //바보모드를 위해 정답을 제외한 랜덤 단어 저장
        self.wrongAnswerForFool = self.keyword.wholeKeywords[self.subject, default: []].filter { $0 != self.answer}.randomElement()!
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
