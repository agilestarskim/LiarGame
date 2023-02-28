//
//  Timer.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/28.
//

import SwiftUI
import Combine

struct Timer: View {
    @EnvironmentObject var game: Game
    @State var remainingTime: Int
    @Binding var isGameEnd: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack{
            Spacer()
            Text("%d seconds".localized(with: remainingTime))
                .font(.largeTitle)
                .onReceive(timer){ _ in
                    if remainingTime > 1 {
                        remainingTime -= 1
                    }else{
                        isGameEnd = true
                    }
                }
            Spacer()
            Button {
                isGameEnd = true
            } label: {
                Text("Vote for liars".localized)
                    .fitButton(color: .red, vertical: 20, horizontal: 20)
                    .shadow(color: .gray, radius: 5, x: 5, y: 5)
            }
            .padding(.top, 50)
            
        }
        .onAppear {
            remainingTime = game.time * 60
            _ = timer.upstream.autoconnect()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onChange(of: remainingTime){ remainingTime in
            //10초에 틱톡 소리가 나오고 1초에 벨소리가 울림
            if remainingTime == 10 {
                SoundManager.instance.play(file: "ticktock")
            } else if remainingTime == 1 {
                SoundManager.instance.stop(file: "ticktock")
                SoundManager.instance.play(file: "bell")
            }
        }
    }
}
