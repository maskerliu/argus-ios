//
//  StoreCategoryDetailVC.swift
//  Argus
//
//  Created by chris on 11/16/20.
//

import SwiftyJSON

class StoreCategoryDetailVC: BaseTableVC {
    private var group: String!
    private var name: String!
    
    private lazy var listData: [BookInfo] = { return [] }()
    
    convenience init(group: String, name: String) {
        self.init()
        
        self.group = group
        self.name = name
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNaviTitle(title: self.name)
        self.setEmpty(scrollView: tableView)
        self.setRefresh(scrollView: tableView, option: .defaults)
        
        self.tableView.estimatedRowHeight = 138
    }
    
    override func refreshData(_ page: Int) {
        BizStoreAPIs.classifyTail(self.group, self.name, page) { resp in
            if page == RefreshPageStart {
                self.listData.removeAll()
            }
            
            if let list: [JSON] = resp["books"].array {
                for item in list {
                    if let model: BookInfo = BookInfo.deserialize(from: item.rawString()) {
                        self.listData.append(model)
                    }
                }
                
                self.tableView.reloadData()
                self.endRefresh(more: list.count >= RefreshPageSize)
            }
            
        } failure: { (error) in
            self.endRefreshFailure()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StoreBookItemCell = StoreBookItemCell.cellForTableView(tableView:tableView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row];
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true);
        let model: BookInfo = self.listData[indexPath.row];
        AGRouter.jumpToBookDetail(bookId: model.bookId ?? "");
    }
}
