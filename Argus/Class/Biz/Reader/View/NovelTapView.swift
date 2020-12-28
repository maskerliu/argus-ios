//
//  NovelTapView.swift
//  Argus
//
//  Created by chris on 11/25/20.
//

import RxCocoa
import RxSwift

private let TAP_SET_HEIGHT = CGFloat(250)
private let TAP_BOTTOM_HEIGHT = CGFloat(100 + TAB_BAR_ADDING)

class NovelTapView: UIView {
    let bag = DisposeBag()
    
    lazy var headerView: NovelHeaderView = {
        let view = NovelHeaderView.instanceView()
        return view
    }()
    
    lazy var bottomView: UIView = { return UIView() }()
    
    lazy var footerView: NovelFooterView = {
        let view = NovelFooterView.instanceView()
        view.btnChapter.rx.tap.subscribe(onNext: { [weak self] in
            self?.showChapterView()
        }).disposed(by: bag)
        view.btnSetting.rx.tap.subscribe(onNext: { [weak self] in
            self?.showSettingView()
        }).disposed(by: bag)
        return view
    }()
    
    lazy var settingView: NovelSettingView = {
        let view = NovelSettingView.instanceView()
        return view
    }()
    
    lazy var chapterView: NovelChapterView = {
        let view = NovelChapterView.instanceView()
        view.isHidden = true
        return view
    }()
    
    lazy var tapView: UIView = {
        let view = UIView.init()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        return view
        
    }()
    
    public var content: NovelContent? {
        didSet {
            guard let item = content else { return }
            
            self.headerView.lTitle.text = content?.title
            self.footerView.slider.maximumValue = Float(item.pageCount - 1)
            self.footerView.slider.minimumValue = 0
            self.footerView.slider.value = Float(item.pageIdx)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.tapView)
        addSubview(self.headerView)
        self.bottomView.addSubview(self.settingView)
        self.bottomView.addSubview(self.footerView)
        addSubview(self.bottomView)
        addSubview(self.chapterView)
        
        isHidden = true
        backgroundColor = UIColor.clear
        self.headerView.isHidden = true
        self.footerView.isHidden = true
        self.settingView.isHidden = true
        self.bottomView.isHidden = true
        self.tapView.isHidden = true
        
        layout()
    }
    
    public func showTapView() {
        self.isHidden = false
        show()
    }
    
    @objc func tapAction(){
        if self.chapterView.isHidden == false {
            hideChapterView()
        } else if self.settingView.isHidden == false {
            hideSettingView()
        } else {
            hide(true)
        }
    }
    
    private func layout() {
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-NAVI_BAR_HIGHT)
            make.height.equalTo(NAVI_BAR_HIGHT)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(TAP_BOTTOM_HEIGHT)
            make.bottom.equalToSuperview().offset(TAP_BOTTOM_HEIGHT)
        }
        
        footerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(TAP_BOTTOM_HEIGHT)
        }
        
        settingView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(TAP_SET_HEIGHT)
            make.top.equalTo(self.bottomView)
        }
        
        chapterView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.7)
            make.left.equalToSuperview().offset(-SCREEN_WIDTH * 0.7)
        }
        
        tapView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.bottomView.snp.top)
        }
    }
    
    private func show() {
        self.bottomView.isHidden = false
        self.footerView.isHidden = false
        self.headerView.isHidden = false
        self.tapView.isHidden = false
        
        headerView.snp.remakeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(NAVI_BAR_HIGHT)
        }
        bottomView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(TAP_BOTTOM_HEIGHT)
        }
        tapView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalTo(self.bottomView.snp.top)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            let vc = UIViewController.rootTopPresentedController()
            vc.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private func hide(_ rootHidden: Bool) {
        headerView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(NAVI_BAR_HIGHT)
            make.top.equalTo(-NAVI_BAR_HIGHT);
        }
        
        bottomView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(TAP_BOTTOM_HEIGHT)
            make.bottom.equalTo(TAP_BOTTOM_HEIGHT);
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            self.bottomView.isHidden = finished
            self.headerView.isHidden = finished
            self.settingView.isHidden = finished
            self.isHidden = rootHidden && finished
            let vc = UIViewController.rootTopPresentedController()
            vc.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @objc private func showChapterView() {
        hide(false)
        self.chapterView.isHidden = false
        self.chapterView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.7)
            make.left.equalToSuperview().offset(0)
        }
        self.tapView.snp.remakeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(self.chapterView.snp.right)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    private func hideChapterView() {
        
        self.chapterView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.7)
            make.left.equalToSuperview().offset(-SCREEN_WIDTH * 0.7)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        }) { (finish) in
            self.isHidden = finish
            self.chapterView.isHidden = finish
            let vc = UIViewController.rootTopPresentedController()
            vc.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @objc private func showSettingView() {
        
        if self.settingView.isHidden == false {
            hideSettingView()
            return
        }
        
        self.settingView.isHidden = false
        self.bottomView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(TAP_SET_HEIGHT + TAP_BOTTOM_HEIGHT)
        }
        self.settingView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(TAP_SET_HEIGHT)
            make.top.equalTo(self.bottomView)
        }
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
    }
    
    private func hideSettingView() {
        self.settingView.isHidden = false
        self.bottomView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(TAP_BOTTOM_HEIGHT)
        }
        self.settingView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(TAP_SET_HEIGHT)
            make.bottom.equalTo(self.footerView.snp.top).offset(TAP_SET_HEIGHT)
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.layoutIfNeeded()
        }) { (finish) in
            self.settingView.isHidden = true
        }
    }
    
}
