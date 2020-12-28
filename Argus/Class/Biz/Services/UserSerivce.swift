//
//  UserSerivce.swift
//  Argus
//
//  Created by chris on 11/4/20.
//

import SwiftyJSON

private let AGUserInfo = "AGUserInfo"

var userInfo = UserService.user()

public class UserService: NSObject {
    public class func saveUser(user: User) {
        userInfo = user
        if let dict = user.toJSON() {
            UserDefaults.standard.set(dict, forKey: AGUserInfo)
            UserDefaults.standard.synchronize()
        }
    }
    
    public class func user() -> User {
        let data = UserDefaults.standard.object(forKey: AGUserInfo)
        if let user = User.deserialize(from: JSON(data as Any).rawString()) {
            return user
        }
        return User()
    }
}
