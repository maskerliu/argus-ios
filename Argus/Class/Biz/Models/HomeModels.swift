//
//  HomeModels.swift
//  Argus
//
//  Created by chris on 11/2/20.
//


import HandyJSON


enum HomeInfoState: Int {
    case DataNet
    case Database
}

class HomeInfo: HandyJSON {
    var books: [BookInfo] = []
    var total: Int? = 0
    var title: String? = ""
    var shorTitle: String? = ""
    var homeId: String? = ""
    var rank: RankItem? = nil
    var state: HomeInfoState? = .DataNet
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.homeId <-- ["homeId", "_id"]
    }
    
    var listData: [BookInfo] {
        get {
            if self.books.count > 0 {
                let count: Int = self.books.count > 3 ? 3 : self.books.count
                return [] + self.books.prefix(count)
            }
            return []
        }
    }
    
    var moreData: Bool {
        get {
            return self.books.count > 3
        }
    }
    
    required init() {}
}
