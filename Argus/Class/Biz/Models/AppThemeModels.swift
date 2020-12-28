//
//  ThemeModels.swift
//  Argus
//
//  Created by chris on 11/6/20.
//

import HandyJSON

enum AppThemeState: Int, HandyJSONEnum {
    case day
    case night
}

class AppTheme: HandyJSON {
    var state: AppThemeState = .day
    var name: String = "白天模式"
    
    required init() {}
}
