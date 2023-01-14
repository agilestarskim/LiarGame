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
    @StateObject var game = Game()
    var navigator: LinkNavigator {
        appDelegate.navigator
      }
    var body: some Scene {
        WindowGroup {
            navigator
                .launch(paths: ["setting"], items: [:])
                .environmentObject(game)
                .preferredColorScheme(.light)
                .ignoresSafeArea()
        }
    }
}
