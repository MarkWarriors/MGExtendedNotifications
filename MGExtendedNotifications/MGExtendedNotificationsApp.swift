//
//  MGExtendedNotificationsApp.swift
//  MGExtendedNotifications
//
//  Created by Marco Guerrieri on 12/09/2023.
//

import SwiftUI

@main
struct MGExtendedNotificationsApp: App {
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard granted else {
                print("You need the authorization for the push notifications!")
                return
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
