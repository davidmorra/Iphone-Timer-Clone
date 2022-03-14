//
//  NotificationManager.swift
//  Timer
//
//  Created by Davit on 06.03.22.
//

import UIKit
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification() {
        print("showing")
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.subtitle = "Timer Ended"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        notificationCenter.add(request)
    }
}
