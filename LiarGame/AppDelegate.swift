//
//  AppDelegate.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//

import LinkNavigator
import SwiftUI


final class AppDelegate: NSObject {
  var navigator: LinkNavigator {
    LinkNavigator(dependency: AppDependency(), builders: AppRouterGroup().routers)
  }
}

extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    true
  }
}
