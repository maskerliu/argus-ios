//
//  PushService.swift
//  Argus
//
//  Created by chris on 12/15/20.
//

import Foundation

import SwiftyJSON

final class UserNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if SocketClient.isConnected() {
            completionHandler([])
            return
        }
        
        completionHandler([.alert, .sound])
    }
    
    
}

final class PushService {
    static let delegate = UserNotificationCenterDelegate()
}

struct PushNotification {
    let host: URL
    let userName: String
    
    init?(raw: [AnyHashable: Any]) {
        guard
            let json = JSON(parseJSON: (raw["ejson"] as? String) ?? "").dictionary,
            let hostStr = json["host"]?.string,
            let host = URL(string: hostStr),
            let userName = json["sender"]?["username"].string
        else { return nil }
        
        self.host = host
        self.userName = userName
    }
}
