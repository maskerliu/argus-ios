//
//  NovelReaderVC.swift
//  Argus
//
//  Created by chris on 11/26/20.
//

import Foundation

class NovelReaderVC: BaseVC {
    
    
    public var chapter: NSInteger = 0
    public var pageIdx: NSInteger = 0
    public var content: NovelContent!
    
    public var emptyData: Bool = false
    
    public lazy var btnRetry: UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 18
        btn.setBackgroundImage(UIImage.imageWithColor(color: AppColor), for: .normal);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(Appxffffff, for: .normal)
        btn.setTitle("点击重试", for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    private lazy var lTitle: UILabel = {
        let label :UILabel = UILabel.init()
        label.textColor = Appx999999
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var lSubTitle: UILabel = {
        let label = UILabel.init();
        label.textColor = Appx999999
        label.font = UIFont.systemFont(ofSize: 12);
        label.textAlignment = .right;
        return label
    }()
    
    private lazy var lLoad: UILabel = {
        let label = UILabel.init()
        label.font  = UIFont.systemFont(ofSize: 18)
        label.textColor = Appx999999
        label.textAlignment = .center
        label.text = "Data loading..."
        return label
    }()
    
    private lazy var readView: NovelReaderView = {
        let readView = NovelReaderView.init(frame: AppFrame)
        readView.backgroundColor = UIColor.clear;
        return readView
    }()
    
    private lazy var mainView: UIImageView = {
        let mainView : UIImageView = UIImageView()
        mainView.isUserInteractionEnabled = false
        return mainView;
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#f7f1e3")
        
        view.addSubview(self.mainView)
        view.addSubview(self.readView)
        view.addSubview(self.lTitle)
        view.addSubview(self.lSubTitle)
        view.addSubview(self.lLoad)
        view.addSubview(self.btnRetry)
        
        layout()
        
        self.mainView.image = NovelSettingService.defaultSkin()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.readView.frame = AppFrame
    }
    
    public func emptyData(empty : Bool){
        self.emptyData = true;
        self.lLoad.text = "数据空空如也.."
        self.btnRetry.isHidden = true
    }
    
    private func layout() {
        lTitle.snp.makeConstraints { make in
            make.top.equalTo(STATUS_BAR_HIGHT - 5);
            make.left.equalTo(20);
        }
        
        lSubTitle.snp.makeConstraints { make in
            make.right.equalTo(-20);
            make.centerY.equalTo(self.lTitle);
            make.left.equalTo(self.lTitle.snp.right).offset(-20);
        }
        
        lLoad.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        btnRetry.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 120, height: 36))
            make.centerX.equalToSuperview()
            make.top.equalTo(self.lLoad.snp.bottom).offset(20)
        }
        
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    
    public func setModel(model: NovelContent, chapter: NSInteger, pageIdx: NSInteger) {
        self.content = model;
        self.pageIdx = pageIdx;
        self.chapter = chapter;
        self.readView.content = model.attrContent(page: pageIdx)
        self.lTitle.text = model.title;
        self.lSubTitle.text = String(pageIdx + 1) + "/" + String(model.pageCount);
        let res : Bool = self.readView.content.string.count == 0 ? false : true
        self.btnRetry.isHidden = res
        self.lLoad.isHidden = res
        self.lLoad.text = "数据加载失败..."
    }
    
    
    
}
