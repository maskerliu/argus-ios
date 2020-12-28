//
//  BookCategoryVC.swift
//  Argus
//
//  Created by chris on 11/6/20.
//

import SkeletonView
import XLPagerTabStrip


class StoreHomeVC: ButtonBarPagerTabStripViewController {
    private lazy var listData:[String] = {
        return ["male","female","press","picture"];
    }()
    
    private lazy var indicatorInfos: [IndicatorInfo] = {
        var arr: [IndicatorInfo] = []
        var indicator = IndicatorInfo(title: "男生")
        indicator.userInfo = "male"
        arr.append(indicator)
        
        indicator = IndicatorInfo(title: "女生")
        indicator.userInfo = "female"
        arr.append(indicator)
        
        indicator = IndicatorInfo(title: "出版社")
        indicator.userInfo = "press"
        arr.append(indicator)
        
        indicator = IndicatorInfo(title: "其他")
        indicator.userInfo = "picture"
        arr.append(indicator)
        
        return arr
    }()
    
    var isReload = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBarView.removeFromSuperview()
        buttonBarView.backgroundColor = .white
        buttonBarView.selectedBar.backgroundColor = UIColor(hex: "3498db")
        buttonBarView.selectedBar.layer.cornerRadius = 2
        
        view.addSubview(buttonBarView)
        buttonBarView.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(buttonBarView.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .black
            oldCell?.backgroundColor = UIColor.white
            newCell?.label.textColor = .black
            newCell?.backgroundColor = UIColor.white

            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = StoreCategoryVC(itemInfo: indicatorInfos[0])
        let child_2 = StoreCategoryVC(itemInfo: indicatorInfos[1])
        let child_3 = StoreCategoryVC(itemInfo: indicatorInfos[2])
        let child_4 = StoreHotAuthorVC(itemInfo: indicatorInfos[3])

        guard isReload else {
            return [child_1, child_2, child_3, child_4]
        }

        var vcs = [child_1, child_2, child_3, child_4]
        for index in vcs.indices {
            let nElements = vcs.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                vcs.swapAt(index, n)
            }
        }
        let nItems = 1 + (arc4random() % 4)
        return Array(vcs.prefix(Int(nItems)))
    }
   
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
}

