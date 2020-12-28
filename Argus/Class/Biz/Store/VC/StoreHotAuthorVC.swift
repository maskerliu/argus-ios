//
//  StoreHotAuthorVC.swift
//  Argus
//
//  Created by chris on 11/12/20.
//

import SkeletonView
import XLPagerTabStrip

class StoreHotAuthorVC: BaseTableVC, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    var titleName: String? {
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
    
    init(style: UITableView.Style, itemInfo: IndicatorInfo) {
        super.init(nibName: nil, bundle: nil)
        self.itemInfo = itemInfo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 138
        tableView.register(HeaderFooterSection.self, forHeaderFooterViewReuseIdentifier: "HeaderIdentifier")
        tableView.register(HeaderFooterSection.self, forHeaderFooterViewReuseIdentifier: "FooterIdentifier")
        tableView.register(StoreBookItemCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        tableView.isSkeletonable = true
        self.setEmpty(scrollView: self.tableView)
        self.setRefresh(scrollView: self.tableView, option: .defaults)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func refreshData(_ page: Int) {
        endRefreshFailure()
    }
    
    
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension StoreHotAuthorVC: SkeletonTableViewDataSource {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CellIdentifier"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StoreBookItemCell.cellForTableView(tableView: tableView, indexPath: indexPath)
//        cell.lTitle.text = "cell -> \(indexPath.row)"
        return cell
    }
    
}

extension StoreHotAuthorVC: SkeletonTableViewDelegate {
    
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return "HeaderIdentifier"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForFooterInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return "FooterIdentifier"
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderIdentifier") as! HeaderFooterSection
        header.lTitle.text = "header -> \(section)"
        return header
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FooterIdentifier") as! HeaderFooterSection
        footer.lTitle.text = "footer -> \(section)"
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
}
