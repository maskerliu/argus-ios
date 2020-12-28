//
//  BookModels.swift
//  Argus
//
//  Created by chris on 11/2/20.
//

import HandyJSON

class BookInfo: HandyJSON {
    var bookId: String? = ""
    var updateTime: TimeInterval = 0
    var author: String? = ""
    var cover: String? = ""
    var shortIntro: String? = ""
    var title: String? = ""
    var majorCate: String? = ""
    var minorCate: String? = ""
    var lstChapter: String? = ""
    
    var retentionRatio: Float! = 0.0
    var latelyFollower: Int? = 0
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.bookId <-- ["bookId", "_id"]
        mapper <<< self.lstChapter <-- ["lastChapter"]
        mapper <<< self.shortIntro <-- ["shortIntro", "longIntro"]
    }
}

class BookDetail: BookInfo {
    var cat: String? = ""
    var chaptersCount: String? = ""
    var creater: String? = ""
    
    var postCount: Int? = 0
    var wordCount: Int? = 0
    
    var hasSticky: Bool? = false
    var hasUpdated: Bool? = false
    var hasCp: Bool? = false
    var isSerial: Bool? = false
    var donate: Bool? = false
    var le: Bool? = false
    var allowVouvher: Bool? = false
    
    var numberLine: Int = 3
}

class BookUpdateInfo: BookDetail {
    var tags: [String] = []
    var copyrightInfo: String = ""
    var updated: String = ""
}

class BookClassify: Codable {
    var title: String? = ""
    var cover: String? = ""
    var monthlyCount: Int? = 0
    var icon: String? = ""
    var bookCount: Int? = 0
    var bookCover: [String]? = []
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case cover
        case monthlyCount
        case icon
        case bookCount
        case bookCover
    }
}

class BookBrowseInfo: HandyJSON {
    var bookId: String? = ""
    var updateTime: TimeInterval = 0
    var chapter: NSInteger? = 0
    var pageIdx: NSInteger? = 0
    
    var book: BookInfo!
    var source: NovelSource!
    var chapterInfo: NovelChapterInfo!
    
    required init() {}
}
