//
//  LocalStorage.swift
//  Argus
//
//  Created by chris on 12/7/20.
//

import Foundation
import RealmSwift

class ConsumeType: Object {
    
    @objc dynamic var name = ""
}

class ConsumeItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var cost = 0
    @objc dynamic var date = Date()
    @objc dynamic var type: ConsumeType?
}
