//
//  AGCache.swift
//  Argus
//
//  Created by chris on 11/3/20.
//

import SwiftyJSON

private let cache = YYMemoryCache.init()

public class AGCache: NSObject {
    
    public class func removeAll() {
        cache.removeAllObjects()
    }
    
    public class func clear(_ key: String) {
        cache.removeObject(forKey: key)
    }
    
    public class func set(_ object: [String: Any], forKey key: String) {
        cache.setObject(object, forKey: key)
    }
    
    public class func get(_ key: String) -> JSON {
        return JSON(cache.object(forKey: key) as Any)
    }
    
}
