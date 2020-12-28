//
//  BookDetailChapterVC.swift
//  Argus
//
//  Created by chris on 11/16/20.
//

class BookDetailChaptersVC: BaseTableVC {
    
    class func vcWithBookId(_ bookId: String) -> Self {
        let vc = BookDetailChaptersVC()
        vc.bookId = bookId
        return vc as! Self
    }
    
    var model: BookInfo?
    
    private var bookId: String? = ""
    private var chapterInfo = NovelChapterInfo()
    private var source = NovelSource()
    
    
    convenience init(bookId: String) {
        self.init()
        self.bookId = bookId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNaviTitle(title: "章节")
        self.setEmpty(scrollView: tableView)
        self.setRefresh(scrollView: tableView, option: .defaults)
        
        self.tableView.estimatedRowHeight = 60
    }
    
    override func refreshData(_ page: Int) {
        if self.bookId!.count > 0 {
            BizBookAPIs.bookSummary(self.bookId!) { (resp: NovelSource) in
                self.source = resp
                
                BizBookAPIs.bookChapters(resp.sourceId!) { resp in
                    self.chapterInfo = resp
                    self.tableView.reloadData()
                    self.endRefresh(more: false)
                } failure: { (error) in
                    self.endRefreshFailure()
                }
                
            } failure: { (error) in
                self.endRefreshFailure()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chapterInfo.chapters.count;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NovelChapterItemCell.cellForTableView(tableView: tableView, indexPath: indexPath);
        let model: NovelChapter = self.chapterInfo.chapters[indexPath.row];
        cell.ivStatus.isHidden = !model.isVip;
        cell.lTitle.text = model.title;
        return cell;
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        AGRouter.jumpToNovel(book: self.model!, chapter: indexPath.row, pageIndex: 0)
    }
}
