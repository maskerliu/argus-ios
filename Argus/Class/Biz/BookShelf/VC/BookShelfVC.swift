//
//  BookShelfVC.swift
//  Argus
//
//  Created by chris on 11/6/20.
//

import Foundation

class BookShelfVC: BaseCollectionVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEmpty(scrollView: self.collectionView)
        self.setRefresh(scrollView: self.collectionView, option: AGRefreshOption(rawValue: AGRefreshOption.header.rawValue | AGRefreshOption.autoHeader.rawValue))
        collectionView.register(StoreCategoryItemCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
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
        let width = (SCREEN_WIDTH - 60)/3.0;
        let height = width * 1.35 + 50;
        return CGSize.init(width: width, height: height);
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = BookShelfItemCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        return cell;
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        GKJump.jumpToClassifyTail(group: self.titleName!, name: model.title!)
    }
}
