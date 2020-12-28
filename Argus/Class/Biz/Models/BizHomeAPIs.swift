//
//  APIs.swift
//  Argus
//
//  Created by chris on 11/2/20.
//

import SwiftyJSON

struct LoadOption: OptionSet {
    public var rawValue: UInt
    
    static var None: LoadOption { return LoadOption(rawValue: 0) }
    static var DataNet: LoadOption { return LoadOption(rawValue: 1<<1) }
    static var Database: LoadOption { return LoadOption(rawValue: 1<<2) }
    static var Default: LoadOption { return LoadOption(rawValue: DataNet.rawValue | Database.rawValue) }
}

class HomeAPIs: NSObject {
    static let mgr = HomeAPIs()
    
    private var completion: ((_ options: LoadOption) -> Void)? = nil
    private lazy var listData: [HomeInfo] = { return [] }()
    private lazy var arrayData: [HomeInfo] = { return []}()
    
    private var bookCase: HomeInfo!
    
    func homeInfo(_ option: LoadOption,
                  success: @escaping ((_ resp: [HomeInfo]) -> Void),
                  failure: @escaping ((_ error: String) -> Void)) {
        let group = DispatchGroup.init()
        var loadVal = option.rawValue & LoadOption.DataNet.rawValue
        let userData = userInfo
        if loadVal == 2 {
            self.arrayData.removeAll()
            if userData.rankData.count > 0 {
                for obj in userData.rankData {
                    let model = obj as RankItem
                    group.enter()
                    HomeAPIs.hot(model.rankId) { resp in
                        if let info = HomeInfo.deserialize(from: resp["ranking"].rawString()) {
                            if info.books.count > 0 {
                                info.state = HomeInfoState.DataNet
                                info.rank = obj
                                self.arrayData.append(info)
                            }
                        }
                    } failure: { error in
                        group.leave()
                    }
                }
            }
        }
        
        loadVal = option.rawValue & LoadOption.Database.rawValue
        if loadVal == 4 {
            group.enter()
//            BookCaseData
        }
    }
    
    class func hot(_ rankId: String,
                   success: @escaping ((_ obj: JSON) -> Void),
                   failure: @escaping ((_ error: String) -> Void)) {
        let path = "/ranking/" + rankId
        BaseAPIMgr.get(path, [:], success, failure)
    }
    
    class func homeSex(success: @escaping ((_ resp: JSON) -> Void),
                       failure: @escaping ((_ error: String) -> Void)) {
        BaseAPIMgr.get("/ranking/gender", [:], success, failure)
    }
    
    class func reloadHomeInfo(option: LoadOption) {
        if HomeAPIs.mgr.completion != nil { HomeAPIs.mgr.completion!(option) }
    }
}


