//
//  SettingViewModel.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//

import SwiftUI


extension SettingView {
    public class ViewModel: ObservableObject {
        
        let normalDescription = "라이어를 찾으면 라이어는 정답을 맞출 기회가 한 번 주어집니다. 정답을 맞추면 라이어 승리, 틀리면 시민 승리입니다."
        let spyDescription = "스파이에게도 키워드를 제공합니다. 스파이는 라이어가 정답을 유추할 수 있도록 질문합니다. 스파이는 라이어를 도와 라이어팀이 승리하도록 이끌어야합니다. 스파이가 지목당하면 시민이 승리합니다."
        let foolDescription = "라이어는 자신이 라이어인지 모릅니다. 라이어는 일반 시민들과 다른 키워드가 주어집니다."
        
    }
}
