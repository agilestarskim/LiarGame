//
//  AppDelegate.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//

import AVFoundation
import LinkNavigator
import SwiftUI


final class AppDelegate: NSObject {
  var navigator: LinkNavigator {
    LinkNavigator(dependency: AppDependency(), builders: AppRouterGroup().routers)
  }
}

extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
      do {
          try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
      } catch let error as NSError {
          print("Error : \(error), \(error.userInfo)")
      }
              
      do {
           try AVAudioSession.sharedInstance().setActive(true)
      }
        catch let error as NSError {
          print("Error: Could not setActive to true: \(error), \(error.userInfo)")
      }
      return true
  }
}
