//
//  BookDetailDescVC.swift
//  Argus
//
//  Created by chris on 11/18/20.
//

import Foundation

class BookDetailDescVC: BaseCollectionVC {
    
    private var bookId: String? = ""
    
    private lazy var listData: [BookInfo] = { return [] }()
    
    public var model: BookDetail? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    convenience init(bookId: String, model: BookDetail? = nil) {
        self.init()
        self.bookId = bookId
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEmpty(scrollView: collectionView)
        setRefresh(scrollView: collectionView, option: AGRefreshOption(rawValue: AGRefreshOption.header.rawValue | AGRefreshOption.autoHeader.rawValue))
        
        self.collectionView.backgroundColor = Appxffffff
        self.collectionView.backgroundView?.backgroundColor = Appxffffff
    }
    
    override func refreshData(_ page: Int) {
        if bookId!.count > 0 {
            BizStoreAPIs.bookCommend(bookId!) { resp in
                if let data = [BookInfo].deserialize(from: resp["books"].rawString()) {
                    self.listData = data as! [BookInfo]
                }
                
                self.collectionView.reloadData()
                self.endRefresh(more: false)
            } failure: { (error) in
                self.endRefreshFailure()
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookShelfItemCell = BookShelfItemCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        cell.model = self.listData[indexPath.row] ;
        return cell;
    }
    
    
    // MARK: - UICollectionViewDeleageLayout
    
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
        let width = (SCREEN_WIDTH - 15 * 4) / 3.0 - 0.1;
        let height = width * 1.35 + 50;
        return CGSize.init(width: width, height: height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: self.model != nil ? StoreBookDetailIntroView.getHeight(model: self.model!) : 0.001)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = StoreBookDetailIntroView.viewForCollectionView(collectionView: collectionView,
                                                                  elementKind: kind,
                                                                  indexPath: indexPath)
        view.isHidden = self.model == nil
        if self.model != nil {
            view.lContent.numberOfLines = self.model!.numberLine
            view.content = self.model?.shortIntro
            view.btnMore.isSelected = self.model?.numberLine == 0
        }
        view.btnMore.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
        return view
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: BookInfo = self.listData[indexPath.row] ;
        AGRouter.jumpToBookDetail(bookId: model.bookId!);
    }
    
    @objc func moreAction(sender: UIButton){
        self.model?.numberLine = self.model?.numberLine == 3 ? 0 : 3
        self.collectionView.reloadData()
    }
}
