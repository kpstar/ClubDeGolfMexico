//
//  AppDelegate.swift
//  Club de Golf México
//
//  Created by admin on 2/14/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import Firebase
import MBProgressHUD
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        IQKeyboardManager.sharedManager().enable = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        
        if UserDefaults.standard.value(forKey: kNotification) == nil {
            UserDefaults.standard.set(true, forKey: kNotification)
        }

        if UserDefaults.standard.value(forKey: kNotificationVibration) == nil {
            UserDefaults.standard.set(true, forKey: kNotificationVibration)
        }

        if UserDefaults.standard.value(forKey: kNotificationTone) == nil {
            UserDefaults.standard.set(ToneOptions.golf.rawValue, forKey: kNotificationTone)            
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if UserDefaults.standard.integer(forKey: kUserID) != 0 {
            let drawerVC = storyboard.instantiateViewController(withIdentifier: "drawerNav") as! UINavigationController
            self.window?.rootViewController = drawerVC
            checkMessages()
        } else {
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginNav") as! UINavigationController
            self.window?.rootViewController = loginVC
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        checkMessages()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkMessages() {
        let user_id = UserDefaults.standard.string(forKey: kUserID) ?? "0"
        
        let params = [user_id]
        
        MBProgressHUD.showAdded(to: self.window!, animated: true)
        
        WebService.shared.sendRequest(codigo: 130, data: params) { (isSuccess, errorMessage, resultData) in
            
            MBProgressHUD.hide(for: self.window!, animated: true)
            
            if isSuccess {
                
                guard let resultArray = resultData else {
                    return
                }
                
                if Int(resultArray[1]) == 1 {
                    
                    for result in resultArray {
                        
                        let obj = JSON(parseJSON: result)
                            
                        if let messageData = obj["data"].dictionaryObject {
                            ProcessMessage.shared.process(JSON(messageData))
                        }
                        
                    }
                    
                } else {
//                    self.showErrorMessage(resultData?[2] ?? "" )
                }
                
                
            } else {
                
//                self.showErrorMessage(errorMessage ?? "")
                
            }
            
        }

    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        ProcessMessage.shared.process(userInfo)
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        ProcessMessage.shared.process(JSON(notification.request.content.userInfo))

        completionHandler([.sound])

    }
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM token: \(fcmToken)")
    }
}

