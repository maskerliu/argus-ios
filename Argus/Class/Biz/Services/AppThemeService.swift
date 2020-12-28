//
//  AppThemeService.swift
//  Argus
//
//  Created by chris on 11/6/20.
//

import SwiftyJSON


private let kAppTheme = "AGAppTheme"

class AppThemeService: NSObject {
    static let mgr = AppThemeService()
    
    var theme: AppTheme? { get { return AppThemeService.theme() }}
    
    class func setState(state: AppThemeState) {
        let theme = AppThemeService.mgr.theme!
        if theme.state != state {
            theme.state = state
            AppThemeService.saveTheme(theme: theme)
        }
    }
    
    class func saveTheme(theme: AppTheme) {
        let defaults = UserDefaults.standard
        if let dict = theme.toJSON() {
            defaults.set(dict, forKey: kAppTheme)
            defaults.synchronize()
        }
    }
    
    class func theme() -> AppTheme {
        let data = UserDefaults.standard.object(forKey: kAppTheme)
        let json = JSON(data as Any)
        if let theme = AppTheme.deserialize(from: json.rawString()) {
            return theme
        }
        return AppTheme()
    }
}
