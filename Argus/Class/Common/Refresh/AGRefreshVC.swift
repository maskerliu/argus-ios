//
//  RefreshVC.swift
//  Argus
//
//  Created by chris on 11/3/20.
//

import UIKit

public let RefreshPageStart: Int = 1

open class AGRefreshVC: UIViewController {
    weak open var scrollView: UIScrollView!
    weak open var dataSource: AGRefreshDataSource? = nil
    
    private var reachable: Bool = netReachable()
    
    private var headerImages: [UIImage] {
        get { return self.dataSource?.refreshHeaderData ?? [] }
    }
    
    private var footerImages: [UIImage] {
        get { return self.dataSource?.refreshFooterData ?? [] }
    }
    
    private var loadImages: UIImage {
        get {
            let images = self.dataSource?.refreshLoadData ?? []
            return UIImage.animatedImage(with: images, duration: 0.35)!
        }
    }
    
    private var errorImage: UIImage {
        get { return self.dataSource?.refreshErrorData ?? UIImage.init() }
    }
    
    private var _emptyImage: UIImage?
    private var emptyImage: UIImage {
        get { return _emptyImage ?? (self.dataSource?.refreshEmptyData ?? UIImage.init()) }
        set { _emptyImage = newValue }
    }
    
    private var _emptyToast: String?
    private var emptyToast: String {
        get { return _emptyToast ?? (self.dataSource?.refreshEmptyToast ?? "data empty") }
        set { _emptyToast = newValue }
    }
    
    private var errorToast: String {
        get { return self.dataSource?.refreshErrorToast ?? "new error" }
    }
    
    private var loadToast: String {
        get { return self.dataSource?.refreshLoadToast ?? "data loading..." }
    }
    
    private var curPage: Int = 0
    private var isSetKVO: Bool = false
    private var _refreshing: Bool = false
    private var refreshing: Bool {
        get { return _refreshing }
        set {
            _refreshing = newValue
            if self.scrollView != nil {
                if self.scrollView!.isEmptyDataSetVisible {
                    self.reloadEmptyData()
                }
            }
        }
    }
    
    deinit {
        print(self.classForCoder, "is deinit")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open func setRefresh(scrollView: UIScrollView, option: AGRefreshOption) {
        self.scrollView = scrollView
        if option.rawValue == AGRefreshOption.none.rawValue {
            if self.responds(to: #selector(headerRefreshing)) {
                self.headerRefreshing()
            }
            return
        }
        
        if option.rawValue & AGRefreshOption.header.rawValue == 1 {
            let header = MJRefreshGifHeader.init(refreshingTarget: self,
                                                 refreshingAction: #selector(headerRefreshing))
            header.stateLabel?.isHidden = true
            header.isAutomaticallyChangeAlpha = true
            header.lastUpdatedTimeLabel?.isHidden = true
            
            if self.headerImages.count > 0 {
                header.setImages([self.headerImages.first as Any], for: .idle)
                header.setImages(self.headerImages, duration: 0.35, for: .refreshing)
            }
            
            if option.rawValue & AGRefreshOption.autoHeader.rawValue == 4 {
                self.headerRefreshing()
            }
            scrollView.mj_header = header
        }
        
        if option.rawValue & AGRefreshOption.footer.rawValue == 2 {
            let footer = MJRefreshAutoGifFooter.init(refreshingTarget: self,
                                                     refreshingAction: #selector(footerRefreshing))
            footer.triggerAutomaticallyRefreshPercent = 1
            footer.stateLabel?.isHidden = false
            footer.labelLeftInset = -22
            if self.footerImages.count > 0 {
                footer.setImages([self.footerImages.first as Any], for: .idle)
                footer.setImages(self.footerImages, duration: 0.35, for: .refreshing)
            }
            footer.setTitle(" —— 我是有底线的 ——  ", for: .noMoreData)
            footer.setTitle("", for: .pulling)
            footer.setTitle("", for: .refreshing)
            footer.setTitle("", for: .willRefresh)
            footer.setTitle("", for: .idle)
            footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
            if option.rawValue & AGRefreshOption.autoFooter.rawValue == 8 {
                if self.curPage == 0 {
                    self.refreshing = true
                }
                self.footerRefreshing()
            } else if option.rawValue & AGRefreshOption.defaultHidden.rawValue == 16 {
                footer.isHidden = true
            }
            scrollView.mj_footer = footer
        }
    }
    
    open func setEmpty(scrollView: UIScrollView) {
        self.setEmpty(scrollView: scrollView, image: nil, title: nil)
    }
    
    open func setEmpty(scrollView: UIScrollView, image: UIImage? = nil, title: String? = nil) {
        scrollView.emptyDataSetSource = self
        scrollView.emptyDataSetDelegate = self
        
        if title != nil {
            self.emptyToast = title!
        }
        
        if image != nil {
            self.emptyImage = image!
        }
        
        if self.isSetKVO { return }
        
        self.isSetKVO = true
        weak var weakSelf = self
        self.kvoController.observe(scrollView, keyPaths: ["contentSize","contentInset"], options: .new) { (observer, object, change) in
            NSObject.cancelPreviousPerformRequests(withTarget: weakSelf as Any, selector: #selector(weakSelf!.reloadEmptyData), object: nil)
            weakSelf!.perform(#selector(weakSelf?.reloadEmptyData), with: nil, afterDelay: 0.01)
        }
    }
    
    open func refreshData(_ page: Int) {
        self.curPage = page
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            if self.scrollView.mj_header != nil{
                if (self.scrollView?.mj_header?.isRefreshing)! || (self.scrollView?.mj_header?.isRefreshing)!{
                    self.endRefreshFailure()
                }
            }
        }
    }
    
    open func endRefresh(more: Bool) {
        self.baseEndRefreshing()
        if self.scrollView.mj_footer == nil { return }
        
        if more {
            self.scrollView?.mj_footer?.state = .idle
            self.scrollView?.mj_footer?.isHidden = false
            let footer = self.scrollView?.mj_footer as! MJRefreshAutoStateFooter
            footer.stateLabel?.textColor = UIColor.init(hex: "666666")
            footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
        } else {
            self.scrollView?.mj_footer?.state = .noMoreData
            let footer = self.scrollView?.mj_footer as! MJRefreshAutoStateFooter
            footer.stateLabel?.textColor = UIColor.init(hex: "999999")
            footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                let height = (self.scrollView?.contentSize.height)!
                let sizeHeight = (self.scrollView?.frame.size.height)!
                self.scrollView?.mj_footer!.isHidden = self.curPage == RefreshPageStart || height < sizeHeight
            }
        }
    }
    
    open func endRefreshFailure(error :String? = nil) {
        if error != nil {
            self.emptyToast = error ?? ""
        }
        if self.curPage > RefreshPageStart {
            self.curPage = self.curPage - 1
        }
        self.baseEndRefreshing()
        if self.scrollView.mj_footer != nil {
            if (self.scrollView?.mj_footer?.isRefreshing)! {
                self.scrollView?.mj_footer?.state = .idle
            }
        }
        self.reloadEmptyData()
    }
    
    @objc open func headerRefreshing() {
        self.refreshing = true
        if self.scrollView.mj_footer != nil {
            self.scrollView?.mj_footer?.isHidden = true
        }
        self.curPage = RefreshPageStart
        self.refreshData(self.curPage)
    }
    
    @objc open func footerRefreshing() {
        if self.refreshing == false {
            self.refreshing = true
            self.curPage = self.curPage + 1
            self.refreshData(self.curPage)
        }
    }
    
    @objc final func reloadEmptyData() {
        if self.scrollView != nil {
            self.scrollView?.reloadEmptyDataSet()
        }
    }
    
    final func baseEndRefreshing() {
        if self.scrollView.mj_header != nil {
            if (self.scrollView?.mj_header?.isRefreshing)! {
                self.scrollView?.mj_header?.endRefreshing()
            }
        }
        self.refreshing = false
    }
}

extension AGRefreshVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    open func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = self.refreshing ? self.loadToast : ((!self.reachable ? self.errorToast : self.emptyToast))
        var dict: [NSAttributedString.Key : Any ] = [:]
        let font = UIFont.systemFont(ofSize: 15)
        let color = UIColor.init(hex: "999999")
        dict.updateValue(font, forKey: .font)
        dict.updateValue(color, forKey: .foregroundColor)
        let attr = NSAttributedString.init(string:"\r\n"+text, attributes:(dict))
        return attr
    }
    
    open func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return nil
    }
    
    open func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let image : UIImage = (self.refreshing ? self.loadImages : self.emptyImage)
        return self.reachable ? image : self.errorImage
    }
    
    open func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    open func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -(naviBarHeight()) / 2
    }
    
    open func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 1
    }
    
    open func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    open func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    open func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return !self.refreshing
    }
    
    open func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.refreshing ? nil : self.headerRefreshing()
    }
}
