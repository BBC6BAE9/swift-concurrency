//
//  Notification.swift
//  SwiftConcurrency
//
//  Created by hong on 3/16/25.
//

import Foundation
import UIKit

// 通知
func test(){
    Task {
        let backgroundNotifications =
        NotificationCenter.default.notifications(
            named: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        for await notification in backgroundNotifications {
            print(notification)
        }
    }
}


func test1(){
    Task{
        let backgroundNotifications =
        NotificationCenter.default.notifications(
            named: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        for await notification in backgroundNotifications {
            print(notification)
            break
        }
    }
}
