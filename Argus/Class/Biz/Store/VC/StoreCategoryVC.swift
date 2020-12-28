//
//  StoreCategoryVC.swift
//  Argus
//
//  Created by chris on 11/12/20.
//

import SwiftyJSON
import SkeletonView
import XLPagerTabStrip

class StoreCategoryVC: BaseCollectionVC, IndicatorInfoProvider {
    
    var itemInfo = IndicatorInfo(title: "View") {
        didSet {
            self.refreshData(1)
        }
    }
    
    private lazy var listData: [BookClassify] = { return [] }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(itemInfo: IndicatorInfo) {
        super.init(nibName: nil, bundle: nil)
        self.itemInfo = itemInfo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEmpty(scrollView: collectionView)
        self.setRefresh(scrollView: collectionView, option: AGRefreshOption(rawValue: AGRefreshOption.header.rawValue | AGRefreshOption.autoHeader.rawValue))
        
        view.isSkeletonable = true
        collectionView.isSkeletonable = true
        collectionView.register(StoreCategoryItemCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func refreshData(_ page: Int) {
        if self.itemInfo.title == nil {
            return
        }
        
        BizStoreAPIs.classify(self.itemInfo.title!) { resp in
            if page == RefreshPageStart {
                self.listData.removeAll()
            }

            if let list: [JSON] = resp[self.itemInfo.userInfo as! String].array {
                for item in list {
                    do {
                        let user = try JSONDecoder().decode(BookClassify.self, from: item.rawData())
                        self.listData.append(user)
                    } catch {}
                }
                
                self.collectionView.reloadData()
                self.endRefresh(more: false)
            }
        } failure: { (error) in
            self.endRefreshFailure()
        }
    }
    
    
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15;
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15);
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SCREEN_WIDTH - 60) / 3.0;
        let height = width * 1.35 + 30;
        return CGSize.init(width: width, height: height);
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = StoreCategoryItemCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row];
        return cell;
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: BookClassify = self.listData[indexPath.row];
        AGRouter.jumpToCategoryDetail(group: self.itemInfo.userInfo as! String, name: model.title!)
    }
}

extension StoreCategoryVC: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CollectionViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
}
