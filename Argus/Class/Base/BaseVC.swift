//
//  BaseVC.swift
//  Argus
//
//  Created by chris on 11/3/20.
//

import UIKit

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    override var prefersStatusBarHidden: Bool { return false }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.view.backgroundColor = UIColor.white
        self.fd_prefersNavigationBarHidden = false
        self.fd_interactivePopDisabled = false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    deinit {
        print(self.classForCoder, "is deinit")
    }
}

