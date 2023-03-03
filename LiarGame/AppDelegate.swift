//
//  AppDelegate.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//

import AVFoundation
import LinkNavigator
import SwiftUI
import StoreKit


final class AppDelegate: NSObject {
  var navigator: LinkNavigator {
    LinkNavigator(dependency: AppDependency(), builders: AppRouterGroup().routers)
  }
}

extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
      //무음모드에서 소리가 나올 수 있게 강제로 오디오세션을 켠다.
//      do {
//          try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//      } catch let error as NSError {
//          print("Error : \(error), \(error.userInfo)")
//      }
//
//      do {
//           try AVAudioSession.sharedInstance().setActive(true)
//      } catch let error as NSError {
//          print("Error: Could not setActive to true: \(error), \(error.userInfo)")
//      }
      
      return true
  }
}
