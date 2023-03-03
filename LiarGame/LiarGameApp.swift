//
//  LiarGameApp.swift
//  LiarGame
//
//  Created by 김민성 on 2022/06/30.
//

import LinkNavigator
import SwiftUI


@main
struct LiarGameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    //Keywords class에서 init과 함께 만들어진 system, custom keywords를 merge하여 game에 주입함.
    //앱 실행과 동시에 game의 keywords는 userDefaults로 부터 데이터를 할당받음.
    @StateObject var game = Game()
    @StateObject var store = Store()
    var navigator: LinkNavigator {
        appDelegate.navigator
      }
    var body: some Scene {
        WindowGroup {
            navigator
                .launch(paths: ["setting"], items: [:])
                .environmentObject(game)
                .environmentObject(store)
                .preferredColorScheme(.light)
                .ignoresSafeArea()
        }
    }
}
