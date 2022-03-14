//
//  AppDelegate.swift
//  Timer
//
//  Created by Davit on 24.02.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let notificationManager = NotificationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationManager.requestAuthorization()
//        notificationManager.sendNotification()

        return true
    }
}
