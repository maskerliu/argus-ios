//
//  NovelSetView.swift
//  Argus
//
//  Created by chris on 11/5/20.
//

import RxCocoa
import RxSwift

@objc protocol NovelSettingDelegate: NSObjectProtocol {
    @objc optional func changeFont(_ view: NovelSettingView)
    @objc optional func changeRead(_ view: NovelSettingView)
    @objc optional func changeSkin(_ view: NovelSettingView)
}

class NovelSettingView: UIView {
    
    let bag = DisposeBag()
    
    weak var delegate: NovelSettingDelegate?
    lazy var listData: [String] = { return NovelSettingService.themes() }()
    
    lazy var ivBrightnessLow: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon_novel_setting_brightness_low"))
        return iv
    }()
    
    lazy var ivBrightness: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon_novel_setting_brightness"))
        return iv
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage.init(named: "icon_slider"), for: .normal)
        slider.rx.value.asObservable().subscribe(onNext: {
            let bright = $0
            UIScreen.main.brightness = CGFloat(bright)
        }).disposed(by: bag)
        return slider
    }()
    
    lazy var btnReduce: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.setTitle("A -", for: .normal)
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.init(hex: "#999999").cgColor
        btn.rx.tap.asObservable().subscribe(onNext: { [weak self] in
            self?.reduceAction()
        }).disposed(by: bag)
        return btn
    }()
    
    lazy var btnAdd: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.setTitle("A +", for: .normal)
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.init(hex: "#999999").cgColor
        btn.rx.tap.asObservable().subscribe(onNext: { [weak self] in
            self?.addAction()
        }).disposed(by: bag)
        return btn
    }()
    
    lazy var lFont: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    lazy var lPageModel: UILabel = {
        let label = UILabel()
        label.text = "翻页方式"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    lazy var sgPageModel: UISegmentedControl = {
        let titles = ["平移", "仿真", "无动画", "滚动"]
        let sg = UISegmentedControl(items: titles)
        sg.selectedSegmentIndex = 0
        sg.rx.selectedSegmentIndex.asObservable().subscribe(onNext: { [weak self] in
            self?.changedBrowseModel($0)
        })
        return sg
    }()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        var collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.backgroundView?.backgroundColor = UIColor.white
        return collectionView
    }()
    
    lazy var dividing: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#888888")
        return view
    }()
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        
        backgroundColor = UIColor.white
        
        addSubview(self.ivBrightnessLow)
        addSubview(self.ivBrightness)
        addSubview(self.slider)
        addSubview(self.btnReduce)
        addSubview(self.lFont)
        addSubview(self.btnAdd)
        addSubview(self.lPageModel)
        addSubview(self.sgPageModel)
        addSubview(self.collectionView)
        addSubview(self.dividing)
        
        layout()
        loadData()
    }
    
    private func layout() {
        ivBrightnessLow.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.left.equalToSuperview().offset(20)
            
        }
        
        ivBrightness.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(self.ivBrightnessLow)
        }
        
        slider.snp.makeConstraints { make in
            make.left.equalTo(self.ivBrightnessLow.snp.right).offset(15)
            make.right.equalTo(self.ivBrightness.snp.left).offset(-15)
            make.centerY.equalTo(self.ivBrightnessLow)
        }
        
        btnReduce.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 30))
            make.top.equalTo(self.ivBrightnessLow.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        btnAdd.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 30))
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(self.btnReduce)
        }
        
        lFont.snp.makeConstraints { make in
            make.left.equalTo(self.btnReduce.snp.right).offset(20)
            make.right.equalTo(self.btnAdd.snp.left).offset(-20)
            make.centerY.equalTo(self.btnReduce)
        }
        
        lPageModel.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.top.equalTo(self.btnReduce.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        }
        
        sgPageModel.snp.makeConstraints { make in
            make.centerY.equalTo(self.lPageModel)
            make.left.equalTo(self.lPageModel.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
            
        }
        
        collectionView.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.lPageModel.snp.bottom).offset(20)
            make.height.equalTo(100)
        }
        
        dividing.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func sliderAction(_ sender: UISlider) {
        UIScreen.main.brightness = CGFloat(sender.value)
    }
    
    private func reduceAction() {
        if Int(novelSet.fontSize) <= 10 {
//            MBProgressHUD.showMessage(on: self, message: "最小字体为10")
            return
        }
        let fontSize = Int(novelSet.fontSize) - 2
        NovelSettingService.setFontSize(Float(fontSize))
        self.lFont.text = String(fontSize) + "px"
        if let mDelegate = self.delegate {
            mDelegate.changeFont?(self)
        }
    }
    
    private func addAction() {
        if Int(novelSet.fontSize) >= 30 {
            SVProgressHUD.show(withStatus: "最大字体为30")
            return
        }
        let fontSize = Int(novelSet.fontSize) + 2
        NovelSettingService.setFontSize(Float(fontSize))
        self.lFont.text = String(fontSize) + "px"
        if let mDelegate = self.delegate {
            mDelegate.changeFont?(self)
        }
    }
    
    private func changedBrowseModel(_ selectedIndex: Int) {
        var model: NovelBrowse
        switch selectedIndex {
        case 1:
            model = .pageCurl
        case 2:
            model = .none
        case 3:
            model = .scroll
        default:
            model = .defaults
        }
        
        NovelSettingService.setBrowse(model)
        if let mDelegate = self.delegate {
            mDelegate.changeRead?(self)
        }
    }
    
    private func loadData() {
        let bright: Float = Float(UIScreen.main.brightness)
        self.slider.value = bright
        self.lFont.text = String(novelSet.fontSize) + "px"
        self.collectionView.reloadData()
    }
    
}

extension NovelSettingView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width:60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = NovelSettingBGColorCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        let model = self.listData[indexPath.row]
        cell.imageV.image = UIImage(named: model)
        
        if model == novelSet.skin.rawValue {
            cell.icon.isHidden = false
            cell.icon.image = UIImage(named: "icon_novel_setting_checked")
        } else {
            cell.icon.isHidden = true
            cell.icon.image = nil
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.listData[indexPath.row]
        if model == novelSet.skin.rawValue {
            return
        }
        NovelSettingService.setSkin(NovelTheme(rawValue: model)!)
        if let myDelegate = self.delegate {
            myDelegate.changeSkin?(self)
        }
        self.collectionView.reloadData();
    }
}
