//
//  NovelSetMgr.swift
//  Argus
//
//  Created by chris on 11/3/20.
//

import Foundation

import SwiftyJSON

let novelSet = NovelSettingService.set()

private let AGNovelSetInfo = "AGNovelSetTheme"

class NovelSettingService: NSObject {
    
    class func set() -> NovelSet {
        let defaults: UserDefaults = UserDefaults.standard
        let data = defaults.object(forKey: AGNovelSetInfo)
        let json = JSON(data as Any)
        if let model: NovelSet = NovelSet.deserialize(from: json.rawString()) {
            return model
        }
        return NovelSet()
    }
    
    class func setNight(_ night: Bool) {
        if novelSet.night != night {
            novelSet.night = night
            saveConfig(novelSet)
        }
    }
    
    
    class func setLandscap(_ landscape: Bool) {
        if novelSet.landscape != landscape {
            novelSet.landscape = landscape
            saveConfig(novelSet)
        }
    }
    
    class func setTradition(_ tradition: Bool) {
        if novelSet.tradition != tradition {
            novelSet.tradition = tradition
            saveConfig(novelSet)
        }
    }
    
    class func setBrightness(_ brightness: Float) {
        if novelSet.brightness != brightness {
            novelSet.brightness = brightness
            saveConfig(novelSet)
        }
    }
    
    class func setFontName(_ fontName: String) {
        if novelSet.fontName != fontName {
            novelSet.fontName = fontName
            saveConfig(novelSet)
        }
    }
    
    class func setFontSize(_ fontSize: Float) {
        if novelSet.fontSize != fontSize {
            novelSet.fontSize = fontSize
            saveConfig(novelSet)
        }
    }
    
    class func setSkin(_ skin: NovelTheme) {
        if novelSet.skin != skin {
            novelSet.skin = skin
            saveConfig(novelSet)
        }
    }
    
    class func setBrowse(_ browse: NovelBrowse) {
        if novelSet.browse != browse {
            novelSet.browse = browse
            saveConfig(novelSet)
        }
    }
    
    class func saveConfig(_ config: NovelSet) {
        let defaults: UserDefaults = UserDefaults.standard
        if let data = config.toJSON() {
            defaults.set(data, forKey: AGNovelSetInfo)
            defaults.synchronize()
        }
    }
    
    class func defaultFont() -> [NSAttributedString.Key: Any] {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = CGFloat(novelSet.lineSpacing)
        paragraphStyle.firstLineHeadIndent = CGFloat(novelSet.firstLineHeadIndent)
        paragraphStyle.paragraphSpacingBefore = CGFloat(novelSet.paragraphSpacingBefore)
        paragraphStyle.paragraphSpacing = CGFloat(novelSet.paragraphSpacing)
        paragraphStyle.alignment = .justified
        paragraphStyle.allowsDefaultTighteningForTruncation = true
        
        var attr: [NSAttributedString.Key: Any] = [:]
        let font: UIFont = UIFont.init(name: novelSet.fontName, size: CGFloat(novelSet.fontSize))!
        let color: UIColor = (novelSet.skin == .caffee || novelSet.skin == .black) ? Appxdddddd : UIColor.init(hex: novelSet.color )
        attr.updateValue(font, forKey: .font)
        attr.updateValue(color, forKey: .foregroundColor)
        attr.updateValue(paragraphStyle, forKey: .paragraphStyle)
        return attr
    }
    
    class func defaultSkin() -> UIImage {
        return UIImage.init(named: novelSet.night ? "bg_black" : novelSet.skin.rawValue)!
    }
    
    class func themes() -> [String] {
        return [NovelTheme.defaults.rawValue,
                NovelTheme.green.rawValue,
                NovelTheme.caffee.rawValue,
                NovelTheme.yellow.rawValue,
                NovelTheme.black.rawValue,
        ]
    }
}
