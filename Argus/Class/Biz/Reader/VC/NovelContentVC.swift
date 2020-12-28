//
//  NovelContentVC.swift
//  Argus
//
//  Created by chris on 11/18/20.
//

import Foundation

class NovelContentVC: BaseVC {
    
    private var pageCtrl: UIPageViewController!
    private var book: BookInfo!
    private var source: NovelSource!
    private var chapterInfo: NovelChapterInfo!
    private var content: NovelContent!
    
    var chapter: NSInteger = 0
    var pageIdx: NSInteger = 0
    private var volice: Float = 0
    private var inits: Bool = false
    
    convenience init(book: BookInfo) {
        self.init()
        self.book = book
    }
    
    private lazy var tapView: NovelTapView = {
        let view = NovelTapView.instanceView()
        view.headerView.delegate = self
        view.footerView.delegate = self
        view.chapterView.delegate = self
        view.settingView.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_interactivePopDisabled = true
        self.fd_prefersNavigationBarHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.setNeedsStatusBarAppearanceUpdate()
        
        loadPagedCtrlUI()
        
        view.addSubview(self.tapView)
        tapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loadData()
    }
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.view);
        if point.x > SCREEN_WIDTH / 3.0 && point.x < SCREEN_WIDTH / 3.0 * 2 {
            if self.tapView.isHidden  {
                self.tapView.showTapView()
            }
        }
    }
    
    private func loadPagedCtrlUI() {
        let vc = NovelReaderVC()
        self.pageCtrl = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        self.pageCtrl.dataSource = self
        self.pageCtrl.delegate = self
        self.pageCtrl.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        self.addChild(self.pageCtrl)
        self.view.addSubview(self.pageCtrl.view)
        self.view.sendSubviewToBack(self.pageCtrl.view)
        self.pageCtrl.didMove(toParent: self)
        
        self.pageCtrl.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    
    private func curCtrl(_ ctrl: NovelReaderVC) {
        if self.pageIdx != ctrl.pageIdx {
            self.pageIdx = ctrl.pageIdx
        }
        
        if self.chapter != ctrl.chapter {
            self.chapter = ctrl.chapter
            self.getNovelContent(chapter: self.chapter)
        }
    }
    
    private var readCtrl: NovelReaderVC? {
        get {
            let vc: NovelReaderVC = NovelReaderVC()
//            vc.btnRetry.addTarget(self, action: #selector(<#T##@objc method#>), for: .touchUpInside)
            if self.content != nil {
                self.getBeforeData()
                self.getAfterData()
                
                vc.setModel(model: self.content, chapter: self.chapter, pageIdx: self.pageIdx)
                self.tapView.content = self.content
                self.tapView.footerView.slider.value = Float(self.pageIdx)
            }
            
            return vc
        }
    }
    
    private var showCtrl: NovelReaderVC? {
        get {
            return self.pageCtrl.viewControllers?.first as? NovelReaderVC
        }
    }
    
    private var beforeCtrl: NovelReaderVC? {
        get {
            let vc = self.showCtrl!
            if self.pageIdx <= 0 && self.chapter <= 0 {
                self.chapter = 0
                self.pageIdx = 0
                return nil
            } else if self.pageIdx <= 0 {
                if vc.chapter == self.chapter {
                    self.chapter -= 1
                    self.getNovelContent(chapter: self.chapter)
                    self.pageIdx = self.content.pageCount - 1
                }
            } else {
                if vc.pageIdx == self.pageIdx {
                    self.pageIdx -= 1
                }
            }
            return self.readCtrl!
        }
    }
    
    private var afterCtrl: NovelReaderVC? {
        get {
            if self.content != nil {
                let vc: NovelReaderVC = self.showCtrl!
                let chapters = self.chapterInfo!.chapters
                if self.pageIdx >= self.content.pageCount - 1 && self.chapter >= chapters.count {
                    return nil
                } else if self.pageIdx >= self.content.pageCount - 1 {
                    if vc.chapter == self.chapter{
                        self.chapter += 1;
                        self.getNovelContent(chapter: self.chapter);
                        self.pageIdx = 0;
                    }
                } else {
                    if vc.pageIdx == self.pageIdx {
                        self.pageIdx += 1;
                    }
                }
                return self.readCtrl!
            }
            return nil
        }
    }
    
    private func getNovelContent(chapter: NSInteger) {
        let info = self.chapterInfo.chapters[chapter]
        self.content = info.content
        
        if info.chapterId.count == 0 {
            let content = NovelContent()
            content.content = "更多精彩内容请耐心等待..."
            self.content = content
        }
        
        self.content.pageContent()
    }
    
    private func getBeforeData() {
        let chapterData = self.chapterInfo!.chapters
        let chapter = self.chapter - 1;
        if chapter >= 0 && chapterData.count > chapter {
            let info = chapterData[chapter]
            BizBookAPIs.bookContent(info.link) { resp in
                AGCache.set(resp.toJSON()!, forKey: info.chapterId)
            } failure: { (error) in
                
            }
        }
    }
    
    private func getAfterData() {
        if self.content.pageCount > 0 {
            let chapterData = self.chapterInfo!.chapters
            let chapter = self.chapter + 1;
            if self.content.pageCount > self.pageIdx && chapterData.count > chapter {
                let info = chapterData[chapter]
                BizBookAPIs.bookContent(info.link) { resp in
                    AGCache.set(resp.toJSON()!, forKey: info.chapterId)
                } failure: { (error) in
                    
                }
            }
        }
    }
    
    private func loadData() {
        BizBookAPIs.bookSummary(self.book.bookId!) { resp in
            self.source = resp
            self.getBookChapters()
        } failure: { (error) in
            self.showEmptyTitle(error)
        }
    }
    
    private func getBookChapters() {
        BizBookAPIs.bookChapters(self.source.sourceId!) { resp in
            self.chapterInfo = resp
            self.getBookContent(self.chapter)
        } failure: { (error) in
            self.showEmptyTitle(error)
        }
    }
    
    private func getBookContent(_ chapter: NSInteger) {
        let info = self.chapterInfo.chapters[chapter];
        BizBookAPIs.bookContent(info.link) { resp in
            self.content = resp
            self.reloadUI()
        } failure: { (error) in
            self.showEmptyTitle(error)
        }
    }
    
    private func reloadUI() {
        self.content.pageContent()
        self.tapView.content = self.content
        let icon = NovelSettingService.set().night ? "icon_novel_read_model_night" : "icon_novel_read_model_day"
        self.tapView.footerView.btnReadModel.setImage(UIImage(named: icon), for: .normal)
        self.tapView.footerView.slider.value = Float(self.pageIdx)
        self.tapView.chapterView.setDatas(listData: self.chapterInfo.chapters)
        self.pageCtrl.setViewControllers([self.readCtrl!], direction: .forward, animated: false, completion: nil)
    }
    
    private func showEmptyTitle(_ title: String) {
        let vc = self.readCtrl!
        vc.emptyData(empty: true)
        self.pageCtrl.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }
    
    private func gotoLastChapter() {
        if self.chapter == 0 {
            SVProgressHUD.showInfo(withStatus: "已经是第一章")
            SVProgressHUD.dismiss(withDelay: 200)
            
            return
        }
        self.chapter = self.chapter - 1
        self.pageIdx = 0
        self.getBookContent(self.chapter)
    }
    
    private func gotoNextChapter() {
        let listData = self.chapterInfo.chapters;
        if self.chapter + 1 >= listData.count {
            SVProgressHUD.showInfo(withStatus: "已经是最后一章")
            SVProgressHUD.dismiss(withDelay: 200)
            return
        }
        self.chapter = self.chapter + 1
        self.pageIdx = 0
        self.getBookContent(self.chapter)
    }
}

extension NovelContentVC: NovelHeaderDelegate {
    func headerView(_ headerView: NovelHeaderView, back: Bool) {
        self.goBack()
        AGCache.removeAll()
    }
    
    func headerView(_ headerView: NovelHeaderView, favi: Bool) {
        
    }
}

extension NovelContentVC: NovelChapterDelegate {
    
    func selectChapter(_ view: NovelChapterView, chapter: NSInteger) {
        self.chapter = chapter
        self.pageIdx = 0
        self.getBookContent(self.chapter)
        self.tapView.tapAction()
    }
}

extension NovelContentVC: NovelFooterDelegate {
    
    
    func lastChapter() {
        gotoLastChapter()
    }
    
    func nextChapter() {
        gotoNextChapter()
    }
    
    func changeReadModel() {
        NovelSettingService.setNight(!NovelSettingService.set().night)
        self.reloadUI()
    }
    
    func showSetting(_ footerView: NovelFooterView) {
        
    }
    
    func setReadProgress(progress: Int) {
        self.pageIdx = progress
        self.reloadUI()
    }
    
}

extension NovelContentVC: NovelSettingDelegate {
    
    func changeFont(_ view: NovelSettingView) {
        reloadUI()
    }
    
    func changeRead(_ view: NovelSettingView) {
        
    }
    
    func changeSkin(_ view: NovelSettingView) {
        reloadUI()
    }
}

extension NovelContentVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let vc: NovelReaderVC = self.pageCtrl.viewControllers?.first as! NovelReaderVC
        self.curCtrl(vc);
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self.beforeCtrl
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return self.afterCtrl!
    }
    
    internal func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        let vc = pageViewController.viewControllers?.first
        if (vc != nil) {
            self.pageCtrl.setViewControllers([vc!], direction: .forward, animated: true, completion: nil);
            return .min;
        }
        return.none;
    }
}
