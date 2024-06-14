//
//  NotificationName+Constant.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/14/24.
//

import Foundation

struct NotificationName {
    static let refreshNotification = Notification.Name(Key.refresh)
}

extension NotificationName {
    private struct Key {
        static let refresh = "Refresj"
    }
}
