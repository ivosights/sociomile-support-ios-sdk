//
//  AppDelegate.swift
//  SociomileSupportSDK
//
//  Created by Meynisa on 04/19/2024.
//  Copyright (c) 2024 Meynisa. All rights reserved.
//

import UIKit
import FirebaseMessaging
import FirebaseCore
import UserNotifications
import Foundation
import SociomileSupportSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    let fcmMessageID = "gcm.message_id"
    var notif: NSDictionary?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        SettingRouter(window: self.window).start()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: {_, _ in})
        }else{
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping(UIBackgroundFetchResult) -> Void){
        if let messageId = userInfo[fcmMessageID]{
            print("MessageID : \(messageId)")
        }
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let deviceToken : [String: String] = ["token": fcmToken ?? ""]
        print("Device token : ", deviceToken)
        
        SocioDataModel.shared.fcmToken(fcmToken ?? "")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[fcmMessageID]{
            print("MessageID : \(messageID)")
        }
        print(userInfo)
        notif = userInfo as NSDictionary
        if #available(iOS 13.0, *) {
            SocioDataModel.shared.notification(notif!)
        }
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .badge, .sound]])
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Device Token :", deviceToken)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail to Register : ", error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[fcmMessageID]{
            print("Message ID from userNotificationCenter didReceive : \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
}
