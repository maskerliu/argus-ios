//
//  BaseRefreshVC.swift
//  Argus
//
//  Created by chris on 11/4/20.
//

import Foundation

import Alamofire

class BaseRefreshVC: AGRefreshVC {
    open var reachable: Bool { return NetworkReachabilityManager.init()!.isReachable }
    
    private lazy var images: [UIImage] = {
        var images: [UIImage] = []
        for i in 0...4 {
            let image = UIImage.init(named: String("loading") + String(i))
            
            if image != nil {
                images.append(image!)
            }
        }
        for i in 0...4 {
            let image = UIImage.init(named:String("loading")+String(4 - i));

            if image != nil {
                images.append(image!);
            }
        }
        return images
    }()
    
    deinit {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }
}

extension BaseRefreshVC: AGRefreshDataSource {
    var refreshHeaderData: [UIImage] { return self.images }
    var refreshFooterData: [UIImage] { return self.images }
    var refreshLoadData: [UIImage] { return self.images }
    var refreshLoadToast: String { return "data loading" }
    var refreshEmptyData: UIImage { return UIImage.init(named: "icon_data_empty") ?? UIImage.init() }
    var refreshEmptyToast: String { return "data empty" }
    var refreshErrorData: UIImage { return UIImage.init(named: "icon_net_error") ?? UIImage.init() }
    var refreshErrorToast: String { return "network error" }
}
