//
//  AppDelegate.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/4.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: kBounds)
        window?.rootViewController = BaseNav(rootViewController: BluetoothHomeVC())
        window?.makeKeyAndVisible()
        
        configIQKeyboardManager()
        setLogger()
        return true
    }
    
    /// 设置RTK SDK日志开关
    func setLogger() {
        RTKLog.setLogEnable(true)
    }
    
    func configIQKeyboardManager() {
        let manager = IQKeyboardManager.shared
        manager.enable = true
        manager.shouldResignOnTouchOutside = true
        manager.enableAutoToolbar = false
    }
}

