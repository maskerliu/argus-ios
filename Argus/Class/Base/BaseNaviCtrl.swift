//
//  BaseNavController.swift
//  Argus
//
//  Created by chris on 10/30/20.
//

import UIKit

class BaseNaviCtrl: UINavigationController {
    private var pushing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self;
        
        if (self.delegate?.responds(to: #selector(getter: interactivePopGestureRecognizer)))! {
            self.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        let navBar: UINavigationBar = UINavigationBar.appearance()
        navBar.titleTextAttributes = self.defaultNavi()
        let image = UIImage.imageWithColor(color: UIColor.init(hex: "ffffff"))
        navBar.setBackgroundImage(image, for: .default)
        navBar.shadowImage = UIImage.init()
        navBar.isTranslucent = false
    }
    
    private func defaultNavi() -> [NSAttributedString.Key: Any] {
        var dict: [NSAttributedString.Key: Any] = [:]
        let font: UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let color: UIColor = Appx181818
        dict.updateValue(font, forKey: .font)
        dict.updateValue(color, forKey: .foregroundColor)
        return dict
    }
    
    override var prefersStatusBarHidden: Bool { return self.visibleViewController!.prefersStatusBarHidden }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    override var shouldAutorotate: Bool { return self.visibleViewController!.shouldAutorotate }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.visibleViewController!.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.visibleViewController!.preferredInterfaceOrientationForPresentation
    }
}

extension BaseNaviCtrl: UINavigationControllerDelegate {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.pushing {
            return
        } else {
            self.pushing = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    func navigationController(_ naviController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.pushing = false
    }
}
