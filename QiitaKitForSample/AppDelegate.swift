//
//  AppDelegate.swift
//  QiitaKitForSample
//
//  Created by 須藤将史 on 2017/11/06.
//  Copyright © 2017年 須藤将史. All rights reserved.
//

import UIKit
import QiitaKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Qiita Authorization
        ApiSession.shared.token = "Your Qiita Personal Access Toke"
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

