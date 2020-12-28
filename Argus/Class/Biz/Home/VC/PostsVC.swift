//
//  PostsVC.swift
//  Argus
//
//  Created by chris on 12/9/20.
//

import Foundation

class PostsVC: BaseTableVC {
    private let bookShelf: String = "我的书架"
    private let browseHistory: String = "浏览记录"
    private let readModel = "阅读模式"
    
    private lazy var listData: [MyItemModel] = { return [] }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEmpty(scrollView: self.tableView)
        self.setRefresh(scrollView: self.tableView, option: .defaults)
    }
    
    override func refreshData(_ page: Int) {
        let model1: MyItemModel = MyItemModel.vcWithModel(icon: "icon_book_shelf", title: bookShelf, subTitle: "您添加进书架的所有书籍")
        let model2: MyItemModel = MyItemModel.vcWithModel(icon: "icon_browse_history", title: browseHistory, subTitle: "你过去3个月的阅读/浏览记录")
        let model3: MyItemModel = MyItemModel.vcWithModel(icon: "icon_read_model", title: readModel, subTitle: "白天/黑夜")
        
        self.listData = [model1, model2, model3]
        self.tableView.reloadData()
        self.endRefreshFailure()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyTableViewCell.cellForTableView(tableView: tableView, indexPath: indexPath)
        
        let model = self.listData[indexPath.row]
        cell.model = model
        cell.dividing.isHidden = indexPath.row + 1 == self.listData.count
        
        if model.title == readModel {
            cell.ivArrow.isHidden = true
            cell.btnSwitch.isHidden = false
        }
        return cell;
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let model = self.listData[indexPath.row];
        if model.title == bookShelf {
            AGRouter.jumpToFlutterVC();
        } else if model.title == browseHistory {
            AGRouter.jumpToBrowse();
        } else {
            
        }
    }
}
