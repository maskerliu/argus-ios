//
//  BizBookAPIs.swift
//  Argus
//
//  Created by chris on 11/16/20.
//

import Foundation

class BizBookAPIs: NSObject {
    
    class func bookSummary(_ bookId: String,
                           success: @escaping ((_ resp: NovelSource) -> Void),
                           failure: @escaping ((_ error: String) -> Void)) {
        BaseAPIMgr.get("/toc", ["book": bookId, "view": "summary"], { resp in
            if let data = [NovelSource].deserialize(from: resp.rawString()) {
                let list: [NovelSource] = data as! [NovelSource]
                
                if list.count > 0 {
                    success(list.first!)
                } else {
                    failure("")
                }
            } else {
                failure("")
            }
        }, failure)
    }
    
    class func bookChapters(_ bookId: String,
                            success: @escaping ((_ resp: NovelChapterInfo) -> Void),
                            failure: @escaping ((_ error: String) -> Void)) {
        
        let url = BaseAPIMgr.hostURL(path: "/toc/" + String(bookId))
        
        BaseApiSystem.sendRequest(url, .get, [:], ["view": "chapters"], { (resp) in
            if let info: NovelChapterInfo = NovelChapterInfo.deserialize(from: resp.rawString()) {
                success(info)
            } else {
                failure("error")
            }
        }, failure)
    }
    
    class func bookContent(_ link: String,
                           success: @escaping ((_ resp: NovelContent) -> Void),
                           failure: @escaping ((_ error: String) -> Void)) {
        let url = "https://chapter2.zhuishushenqi.com/chapter/" + (link.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? "")
        BaseAPIMgr.sendRequest(url, .get, [:], [:], { resp in
            if let model: NovelContent = NovelContent.deserialize(from: resp["chapter"].rawString()) {
                success(model)
            } else {
                failure("error")
            }
        }, failure)
    }
    
}
