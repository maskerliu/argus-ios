//
//  RankInfo.swift
//  Argus
//
//  Created by chris on 11/2/20.
//

import UIKit
import HandyJSON

class RankItem: HandyJSON {
    var rankId: String = ""
    var monthRank: String = ""
    var totalRank: String = ""
    
    var collapse: String? = ""
    var cover: String? = ""
    var shortTitle: String? = ""
    var title: String? = ""
    var select: Bool? = false
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.rankId <-- ["rankId", "_id"]
    }
    
    required init() {}
}

class RankInfo: HandyJSON {
    var male: [RankItem]? = []
    var female: [RankItem]? = []
    var picture: [RankItem]? = []
    var epub: [RankItem]? = []
    var state: Int? = 0
    
    var boyDatas: [RankItem]? {
        get {
            let listData = userInfo.rankData
            if listData.count > 0 {
                listData.forEach { (obj) in
                    let list: [RankItem] = self.male?.filter({ (item) -> Bool in
                        item.rankId == obj.rankId
                    }) ?? []
                    if list.count > 0 {
                        let item: RankItem = list.first!
                        item.select = true
                    }
                }
            }
            return male
        }
    }
    
    var girlData: [RankItem]? {
        get {
            let listData = userInfo.rankData
            if listData.count > 0 {
                listData.forEach { (obj) in
                    let list: [RankItem] = self.female?.filter({ (item) -> Bool in
                        item.rankId == obj.rankId
                    }) ?? []
                    if list.count > 0 {
                        let item: RankItem = list.first!
                        item.select = true
                    }
                }
            }
            return female
        }
    }
    
    required init() {}
}
