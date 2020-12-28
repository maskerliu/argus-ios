//
//  StoreModels.swift
//  Argus
//
//  Created by chris on 11/12/20.
//

import Foundation

class StoreCategory: Codable {
    var title: String? = ""
    var cover: String? = ""
    var monthlyCount: Int? = 0
    var icon: String? = ""
    var bookCount: Int? = 0
    var bookCover: [String]? = []
    
    enum CodingKeys: String, CodingKey {
        case title = "names"
        case cover
        case monthlyCount
        case icon
        case bookCount
        case bookCover
    }
}
