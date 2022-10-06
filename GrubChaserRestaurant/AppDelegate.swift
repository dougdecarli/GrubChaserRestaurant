//
//  AppDelegate.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 03/10/22.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        Starter.startFlow(window: window)
        window?.makeKeyAndVisible()
        window?.tintColor = ColorPallete.defaultRed
        return true
    }
}

