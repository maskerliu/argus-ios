//
//  BizStoreAPIs.swift
//  Argus
//
//  Created by chris on 11/13/20.
//

import SwiftyJSON

//public let RefreshPageStart : Int = (1)
public let RefreshPageSize: Int = (20)

class BizStoreAPIs: NSObject {
    class func classify(_ category: String,
                        success: @escaping ((_ resp: JSON) -> Void),
                        failure: @escaping ((_ error: String) -> Void)) {
        BaseAPIMgr.get("/cats/lv2/statistics", [:], success, failure)
    }
    
    class func classifyTail(_ group: String, _ name: String, _ page: NSInteger,
                            success: @escaping ((_ resp: JSON) -> Void),
                            failure: @escaping ((_ error: String) -> Void)) {
        let params:Dictionary = ["gender": group,
                                 "type": "hot",
                                 "major": name,
                                 "start": String((page - 1) * RefreshPageSize + 1),
                                 "limit": String(RefreshPageSize),
                                 "minor": ""]
        BaseAPIMgr.get("/book/by-categories", params, success, failure)
    }
    
    class func bookDetail(_ bookId: String,
                          success: @escaping ((_ resp: JSON) -> Void),
                          failure: @escaping ((_ error: String) -> Void)) {
        BaseAPIMgr.get("/book/"+(bookId), [:], success, failure)
    }
    
    class func bookUpdate(_ bookId: String,
                          success: @escaping ((_ resp: JSON) ->Void),
                          failure: @escaping ((_ error: String) ->Void)) {
        BaseAPIMgr.get("/book/"+(bookId), ["id":bookId,"view":"updated"], success, failure)
    }
    
    class func bookCommend(_ bookId: String,
                           success: @escaping ((_ resp: JSON) -> Void),
                           failure: @escaping ((_ error: String) -> Void)){
        BaseAPIMgr.get("/book/"+(bookId)+"/recommend", [:], success, failure)
    }
    class func bookSearch(_ hotWord: String,
                          _ page: NSInteger,
                          _ size: NSInteger,
                          success: @escaping ((_ resp: JSON) -> Void),
                          failure: @escaping ((_ error: String) -> Void)) {
        BaseAPIMgr.get("/book/fuzzy-search",
                       ["query": hotWord, "start": String(page - 1), "limit": String(size)],
                       success, failure)
    }
}
