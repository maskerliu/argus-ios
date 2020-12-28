//
//  TabBarController.swift
//  Argus
//
//  Created by chris on 10/30/20.
//

import UIKit


class BizTabBarVC: UITabBarController {
    private lazy var vcs: [UIViewController] = { return [] }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false
        self.createVC(vc: HomeVC(), title: "首页", normal: "icon_tabbar_home_n", select: "icon_tabbar_home_h")
        self.createVC(vc: StoreHomeVC(), title: "分类", normal: "icon_tabbar_found_n", select: "icon_tabbar_found_h")
        self.createVC(vc: BookShelfVC(), title: "书架", normal: "icon_tabbar_store_n", select: "icon_tabbar_store_h")
        self.createVC(vc: MyVC(), title: "我的", normal: "icon_tabbar_my_n", select: "icon_tabbar_my_h")
        self.viewControllers = self.vcs
        
    }
    
    private func createVC(vc: UIViewController, title: String, normal: String, select: String) {
        let nv = BaseNaviCtrl(rootViewController: vc)
        vc.showNaviTitle(title: title)
        nv.tabBarItem.title = title
        nv.tabBarItem.image = UIImage(named: normal)?.withRenderingMode(.alwaysOriginal)
//        nv.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        nv.tabBarItem.selectedImage = UIImage(named: select)?.withRenderingMode(.alwaysOriginal)
        nv.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColor as Any], for: .selected)
        nv.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Appx999999 as Any], for: .normal)
        self.vcs.append(nv)
    }
}
