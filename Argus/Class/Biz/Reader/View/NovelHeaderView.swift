//
//  NovelTopView.swift
//  Argus
//
//  Created by chris on 11/25/20.
//

import RxCocoa
import RxSwift

@objc protocol NovelHeaderDelegate: NSObjectProtocol {
    
    @objc optional func headerView(_ headerView: NovelHeaderView, back: Bool)
    
    @objc optional func headerView(_ headerView: NovelHeaderView, favi: Bool)
}

class NovelHeaderView: UIView {
    let bag = DisposeBag()
    
    weak var delegate: NovelHeaderDelegate?
    
    lazy var btnBack: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon_close"), for: .normal)
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.back()
        })
        return btn
    }()
    
    lazy var btnFavi: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon_favi"), for: .normal)
        btn.setImage(UIImage(named: "icon_favi_selected"), for: .selected)
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.favi()
        }).disposed(by: bag)
        return btn
    }()
    
    lazy var lTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(self.btnBack)
        addSubview(self.btnFavi)
        addSubview(self.lTitle)
        
        layout()
    }
    
    private func layout() {
        btnBack.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
        }
        
        btnFavi.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        
        lTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(75)
            make.right.equalToSuperview().offset(-75)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func back() {
        if let delegate = self.delegate {
            delegate.headerView?(self, back: true)
        }
    }
    
    private func favi() {
        if let delegate = self.delegate {
            delegate.headerView?(self, favi: true)
        }
    }
    
}
