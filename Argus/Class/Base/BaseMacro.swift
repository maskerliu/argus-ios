//
//  BaseMacro.swift
//  Argus
//
//  Created by chris on 10/30/20.
//

import UIKit

import SwiftyJSON
import HandyJSON
import Alamofire

let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

let IS_IPHONE_X: Bool = isIPhoneX()
let STATUS_BAR_HIGHT: CGFloat = IS_IPHONE_X ? 44 : 20  //状态栏
let NAVI_BAR_HIGHT: CGFloat = IS_IPHONE_X ? 88 : 64  //导航栏
let TAB_BAR_ADDING: CGFloat = IS_IPHONE_X ? 32 : 0  //iphoneX斜刘海

let AppColor: UIColor = UIColor(hex: "007EFE")
let Appxdddddd: UIColor = UIColor(hex:BaseMacro.Axdddddd())
let Appx000000: UIColor = UIColor(hex:BaseMacro.Ax000000())
let Appx181818: UIColor = UIColor(hex:BaseMacro.Ax181818())
let Appx333333: UIColor = UIColor(hex:BaseMacro.Ax333333())
let Appx666666: UIColor = UIColor(hex:BaseMacro.Ax666666())
let Appx999999: UIColor = UIColor(hex:BaseMacro.Ax999999())
let Appxf8f8f8: UIColor = UIColor(hex:BaseMacro.Axf8f8f8())
let Appxffffff: UIColor = UIColor(hex:BaseMacro.Axffffff())
let AppRadius: CGFloat = 3


let AppFrame :CGRect = CGRect.init(x: 20, y: STATUS_BAR_HIGHT + 20, width: SCREEN_WIDTH - 40, height: CGFloat(SCREEN_HEIGHT - STATUS_BAR_HIGHT - 20 - 20 - TAB_BAR_ADDING));


let placeholder: UIImage = UIImage.imageWithColor(color:UIColor(hex: "f4f4f4"))

enum GKThemeState: Int, HandyJSONEnum {
    case Day
    case Night
}

class BaseMacro: NSObject {
    class func Axffffff() -> String {
        let theme = AppThemeService.mgr.theme
        return theme?.state == AppThemeState.day ? "ffffff" : "181818"
    }
    
    class func Axdddddd() -> String {
        let theme = AppThemeService.mgr.theme
        return theme?.state == AppThemeState.day ? "dddddd" : "ededed"
    }
    
    class func Ax000000() -> String {
        let theme = AppThemeService.mgr.theme
        return theme?.state == AppThemeState.day ? "000000" : "ffffff"
    }
    
    class func Ax181818() -> String {
        let theme = AppThemeService.mgr.theme
        return theme?.state == AppThemeState.day ? "181818" : "ffffff"
    }
    
    class func Ax333333() -> String {
        let theme = AppThemeService.mgr.theme
        return theme?.state == AppThemeState.day ? "333333" : "ffffff"
    }
    
    class func Ax666666() -> String {
        let theme = AppThemeService.mgr.theme
        return theme?.state == AppThemeState.day ? "666666" : "ffffff"
    }
    
    class func Ax999999() -> String {
        let theme = AppThemeService.mgr.theme
        return theme?.state == AppThemeState.day ? "999999" : "999999"
    }
    
    class func Axf8f8f8() -> String{
        let theme = AppThemeService.mgr.theme
        return theme?.state == AppThemeState.day ? "f8f8f8" : "181818"
    }
    
    class func Axf4f4f4() -> String{
        let theme = AppThemeService.mgr.theme
        return theme?.state == AppThemeState.day ? "f4f4f4" : "252631"
    }
}

public func netReachable() -> Bool {
    return NetworkReachabilityManager.init()!.isReachable
}

public func isIPhoneX() -> Bool {
    let window : UIWindow = ((UIApplication.shared.delegate?.window)!)!
    if #available(iOS 11.0, *) {
        let inset : UIEdgeInsets = window.safeAreaInsets
        if (inset.bottom == 34 || inset.bottom == 21) && isIPhone() {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

public func isIPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

public func naviBarHeight() -> CGFloat {
    return isIPhoneX() ? 88 : 64
}

public extension UIImage {
    class func imageWithColor(color:UIColor) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

public func sizeFor(i5: CGFloat, i6: CGFloat, i6p:CGFloat, ipad:CGFloat) -> CGFloat {
    if DeviceType.IS_IPHONE_5 {
        return i5
    } else if DeviceType.IS_IPHONE_6 {
        return i6
    } else if DeviceType.IS_IPHONE_6P {
        return i6p
    } else if DeviceType.IS_IPAD {
        return ipad
    }
    return i5
}
