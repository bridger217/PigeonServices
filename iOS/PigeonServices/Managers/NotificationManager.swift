//
//  NotificationManager.swift
//  PigeonServices
//
//  Created by Bridge Dudley on 7/17/23.
//

import Foundation
import OneSignal
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    
    func setup() {
        OneSignal.setNotificationWillShowInForegroundHandler(notificationWillShowInForegroundBlock)
    }
    
    func receivedBackgroundNotification(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let customOSPayload = userInfo["custom"] as? NSDictionary,
              let additionalData = customOSPayload["a"] as? NSDictionary,
              let newMem = additionalData["newMemory"] as? Bool,
              newMem else {
            return
        }
        SceneDelegate.shared()?.getTabBarVC()?.getTodaysMemoryVC()?.refreshMemory()
    }
    
    private let notificationWillShowInForegroundBlock: OSNotificationWillShowInForegroundBlock = { notification, completion in
        SceneDelegate.shared()?.getTabBarVC()?.getTodaysMemoryVC()?.refreshMemory()
        completion(notification)
    }
}
