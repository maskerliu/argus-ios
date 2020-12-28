//
//  BrowseHistory.swift
//  Argus
//
//  Created by chris on 11/10/20.
//

import Foundation

class BrowseHistoryVC: BaseTableVC {
    
    private lazy var listData: [BookBrowseInfo] = { return [] }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNaviTitle(title: "浏览记录")
        self.setEmpty(scrollView: self.tableView);
        self.setRefresh(scrollView: self.tableView, option: .defaults);
    }
    
    override func refreshData(_ page: Int) {
        let bookInfo = BookInfo()
        bookInfo.author = ""
        bookInfo.updateTime = 0.0
        bookInfo.minorCate = "都市生活"
        bookInfo.lstChapter = "后记 揭匾远东商会"
        bookInfo.shortIntro = "一件枪案，一名卧底横死街头。一位办案人，曾在庄严的国徽下宣誓。命运的路口，一位孪生兄弟粉墨登场，引出一段孤独且热血的故事……梦回1998！兄弟还在，青春还在，我们从这里再次扬帆起航，铸就下一个辉煌！"
        bookInfo.bookId = "5a4b46106c81b81b70301c16"
        bookInfo.latelyFollower = 4271
        bookInfo.cover = "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F2201994%2F2201994_8962ad94bda448ac84933ff1ae534ac4.jpg%2F"
        bookInfo.title = "正道潜龙"
        bookInfo.author = "伪戒"
        bookInfo.retentionRatio = 64.08
        bookInfo.majorCate = "都市"
        
        
        let source = NovelSource()
        source.lastChapter = "后记 揭匾远东商会"
        source.chaptersCount = 2087
        source.host = "vip.zhuishushenqi.com"
        source.isCharge = false
        source.source = "zhuishuvip"
        source.sourceId = "5a4b46106c81b81b70301c18"
        source.updated = "2019-11-25T06:36:55.193Z"
        source.starting = "true"
        source.link = "http://vip.zhuishushenqi.com/toc/5a4b46106c81b81b70301c18"
        source.name = "优质书源"
        
        let browseInfo = BookBrowseInfo()
        browseInfo.chapter = 0
        browseInfo.pageIdx = 0
        browseInfo.source = source
        browseInfo.book = bookInfo
        browseInfo.updateTime = 1605002185.919769
        browseInfo.bookId = "5a4b46106c81b81b70301c16"
        
        self.listData.append(browseInfo)
//        GKBrowseDataQueue.getBookModel(page: page, size: (20)) { (object) in
//            if page == 1{
//                self.listData.removeAll();
//            }
//            self.listData.append(contentsOf: object);
//            self.tableView.reloadData();
//            if self.listData.count == 0{
//                self.endRefreshFailure();
//            }else{
//                self.endRefresh(more: object.count >= 20);
//            }
//        }
        
        self.endRefreshFailure()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BrowseHistoryCell = BrowseHistoryCell.cellForTableView(tableView: tableView, indexPath: indexPath)
        let browseInfo: BookBrowseInfo = self.listData[indexPath.row];
        let time: String = "2020.11.10 14:50";
        cell.model = browseInfo.book;
        cell.lSubTitle.text = "上次阅读到：第1" + "章，第2页" + "\n上次阅读时间： " + time;
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let model :BookBrowseInfo = self.listData[indexPath.row];
//        GKJump.jumpToNovel(bookModel: model.book);
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row :UITableViewRowAction = UITableViewRowAction.init(style: .default, title: "删除") { (row, index) in
            self.deleteAction(indexPath: indexPath);
        };
        return [row];
    }
    
    func deleteAction(indexPath:IndexPath){
        AGAlertViews.showAlertView(title: "确定删除该记录", message:"", normals:["取消"], hights: ["确定"]) { (title , index) in
            if index > 0 {
                self.listData.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
    }
}
