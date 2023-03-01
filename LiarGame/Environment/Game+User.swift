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
}
