//
//  NovelFooterView.swift
//  Argus
//
//  Created by chris on 11/25/20.
//

import RxCocoa
import RxSwift


@objc protocol NovelFooterDelegate: NSObjectProtocol {
    @objc optional func lastChapter()
    @objc optional func nextChapter()
    @objc optional func changeReadModel()
    @objc optional func showSetting()
    @objc optional func setReadProgress(progress: Int)
}

class NovelFooterView: UIView {
    
    let bag = DisposeBag()
    
    weak var delegate: NovelFooterDelegate?
    
    lazy var btnLast: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .selected)
        btn.setTitle("上一章", for: .normal)
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.delegate?.lastChapter?()
        }).disposed(by: bag)
        return btn
    }()
    
    lazy var btnNext: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .selected)
        btn.setTitle("下一章", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.delegate?.nextChapter?()
        }).disposed(by: bag)
        return btn
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.rx.value.asObservable().subscribe(onNext: { [weak self] in
            self?.delegate?.setReadProgress?(progress: Int($0))
        }).disposed(by: bag)
        return slider
    }()
    
    lazy var btnChapter: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon_novel_chapter"), for: .normal)
        return btn
    }()
    
    lazy var btnSetting: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon_novel_setting"), for: .normal)
        return btn
    }()
    
    lazy var btnReadModel: UIButton = {
        let btn = UIButton()
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.delegate?.changeReadModel?()
        }).disposed(by: bag)
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(self.btnLast)
        addSubview(self.btnNext)
        addSubview(self.slider)
        addSubview(self.btnChapter)
        addSubview(self.btnReadModel)
        addSubview(self.btnSetting)
        
        layout()
    }
    
    private func layout() {
        btnLast.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 20))
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
        }
        
        btnNext.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 20))
            make.top.equalTo(self.btnLast)
            make.right.equalToSuperview().offset(-15)
        }
        
        slider.snp.makeConstraints { make in
            make.left.equalTo(self.btnLast.snp.right).offset(15)
            make.right.equalTo(self.btnNext.snp.left).offset(-15)
            make.centerY.equalTo(self.btnLast)
        }
        
        btnChapter.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 45, height: 45))
            make.top.equalTo(self.btnLast.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(40)
        }
        
        btnReadModel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 45, height: 45))
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.btnChapter)
        }
        
        btnSetting.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 45, height: 45))
            make.right.equalToSuperview().offset(-40)
            make.centerY.equalTo(self.btnChapter)
        }
    }
    
    @objc func onReadProgress(_ sender: UISlider) {
        if self.delegate != nil {
            self.delegate?.setReadProgress?(progress: Int(sender.value))
        }
    }
    
}
