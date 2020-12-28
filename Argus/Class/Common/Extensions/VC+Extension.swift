//
//  VC+Extension.swift
//  Argus
//
//  Created by chris on 11/3/20.
//

import Foundation

@objc extension UIViewController {
    open func showNaviTitle(title: String?) {
        self.showNaviTitle(title: title, back: true)
    }
    
    open func showNaviTitle(title: String?, back: Bool) {
        self.navigationItem.title = title ?? ""
        if back {
            self.setBackItem(backItem: UIImage.init(named: "icon_navi_back"))
        } else {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.hidesBackButton = true
        }
    }
    
    open func setBackItem(backItem: UIImage?) {
        self.setBackItem(backItem: backItem, closeItem: UIImage.init(named: "icon_navi_close"))
    }
    
    open func setBackItem(backItem: UIImage?, closeItem: UIImage?) {
        if self.navigationController != nil {
            if self.navigationController?.viewControllers.count == 1 && self.presentationController != nil {
                self.navigationItem.leftBarButtonItem = self.naviItem(rightItem: false, image: closeItem,
                                                                      title: (closeItem != nil) ? nil : "ㄨ",
                                                                      color: nil,
                                                                      target: self,
                                                                      action: #selector(goBack))
            } else if (self.navigationController?.viewControllers.count)! > 1 || self.navigationController == nil || self.parent != nil {
                self.navigationItem.leftBarButtonItem = self.naviItem(rightItem: false, image: backItem,
                                                                      title: backItem != nil ? nil : "ㄑ",
                                                                      color: nil,
                                                                      target: self,
                                                                      action: #selector(goBack))
            } else {
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.hidesBackButton = true
            }
            
            if self.navigationItem.leftBarButtonItem?.customView != nil {
                let btn: UIButton = (self.navigationItem.leftBarButtonItem?.customView as? UIButton)!
                btn.contentHorizontalAlignment = .left
            }
        }
    }
    
    open func goBack() {
        self.back(animated: true)
    }
    
    open func back(animated: Bool) {
        if self.navigationController?.viewControllers != nil {
            if (self.navigationController?.viewControllers.count)! > 1 {
                self.navigationController?.popViewController(animated: animated)
            } else if self.presentationController != nil {
                self.dismiss(animated: animated, completion: nil)
                self.view.endEditing(true)
            }
        } else {
            if self.presentationController != nil {
                self.dismiss(animated: animated, completion: nil)
                self.view.endEditing(true)
            }
        }
    }
    
    open func naviItem(rightItem: Bool, image: UIImage?, title: String?, color: UIColor?, target: Any?, action: Selector) -> UIBarButtonItem {
        let btn: UIButton = UIButton.init(type: .custom)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setTitle(title, for: .normal)
        btn.setImage(image ?? UIImage.init(), for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        btn.setTitleColor(color ?? UIColor.gray, for: .normal)
        btn.contentHorizontalAlignment = rightItem ? .right : .left
        return UIBarButtonItem.init(customView: btn)
    }
    
    open func setNaviRightItem(image: UIImage?, title: String?, color: UIColor?, action: Selector) {
        self.navigationItem.rightBarButtonItem = self.naviItem(rightItem: true, image: image, title: title, color: color, target: self, action: action)
    }
    
    open class func rootTopPresentedController()->UIViewController{
        return self.rootTopPresentedVCWithKeys(keys: nil)
    }

    open class func rootTopPresentedVCWithKeys(keys: [String]? = nil) -> UIViewController {
        let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        return (window.rootViewController?.topPresentedControllerWithKeys(keys))!
    }
    
    open func topPresentedController() -> UIViewController {
        return self.topPresentedControllerWithKeys(nil)
    }
    
    open func topPresentedControllerWithKeys(_ keys: [String]? = nil) -> UIViewController {
        let top: [String] = keys ?? ["centerViewController", "contentViewController"]
        var rootVC: UIViewController = self
        if rootVC is UITabBarController {
            let tabVC: UITabBarController = rootVC as! UITabBarController
            let vc = tabVC.selectedViewController != nil ? tabVC.selectedViewController : tabVC.children.first
            if vc != nil {
                return vc!.topPresentedControllerWithKeys(top)
            }
        }
        
        for str in top {
            if rootVC.responds(to: NSSelectorFromString(str)) {
                let vc = rootVC.perform(NSSelectorFromString(str))
                let ct = vc?.takeUnretainedValue()
                
                if ct is UIViewController {
                    let ctrl: UIViewController = ct as! UIViewController
                    return ctrl.topPresentedControllerWithKeys(top)
                }
            }
        }
        
        while rootVC.presentedViewController != nil && rootVC.presentedViewController?.isBeingDismissed == false {
            rootVC = rootVC.presentedViewController!
        }
        
        if rootVC is UINavigationController {
            let nvc: UINavigationController = rootVC as! UINavigationController
            rootVC = nvc.topViewController!
        }
        
        return rootVC
    }
}
