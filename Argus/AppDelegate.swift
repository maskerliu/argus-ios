//
//  AppDelegate.swift
//  Argus
//
//  Created by chris on 9/25/20.
//

import UIKit

//import Flutter
//import FlutterPluginRegistrant

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
//    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
//        flutterEngine.run()
//        GeneratedPluginRegistrant.register(with: self.flutterEngine)
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BizTabBarVC()
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        return true
    }

    
}
