//
//  AppRouterGroup.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/13.
//
import LinkNavigator

struct AppRouterGroup {
  var routers: [RouteBuilder] {
    [
        SettingRouteBuilder(),
        GameRouteBuilder(),
        ChoiceRouteBuilder(),
        LastChanceRouteBuilder(),
        ResultRouteBuilder()        
    ]
  }
}
