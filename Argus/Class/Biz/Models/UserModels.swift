//
//  User.swift
//  Argus
//
//  Created by chris on 11/4/20.
//

import HandyJSON

public enum UserState: Int, HandyJSONEnum {
    case man
    case female
}

public class User: HandyJSON {
    var state: UserState = .man
    var rankData: [RankItem] = []
    
    required public init() {}
}


