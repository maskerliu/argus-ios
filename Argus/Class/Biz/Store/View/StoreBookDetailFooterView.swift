//
//  StoreBookDetailTabView.swift
//  Argus
//
//  Created by chris on 11/16/20.
//

import Foundation

class StoreBookDetailFooterView: UIView {
    
    lazy var btnRead: UIButton = {
        let btn = UIButton()
        btn.setTitle("立即阅读", for: .normal)
        btn.backgroundColor = UIColor(hex: "#3498db")
        btn.tintColor = UIColor(hex: "#2980b9")
        return btn
    }()
    
    lazy var vLeft: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    
    lazy var btnFavi: AGFaviButton = {
        return AGFaviButton(frame: .zero, image: UIImage(named: "icon_favi"))
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.vLeft)
        addSubview(self.btnRead)
        self.vLeft.addSubview(self.btnFavi)
        
        self.btnFavi.imageColorOn = AppColor
        self.btnFavi.circleColor = AppColor
        self.btnFavi.lineColor = AppColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        
        self.vLeft.snp.remakeConstraints { make in
            make.left.equalTo(self)
            make.width.equalTo(self.frame.size.width / 3)
            make.height.equalTo(self)
        }
        
        self.btnRead.snp.remakeConstraints { make in
            make.left.equalTo(self.vLeft.snp.right)
            make.right.equalTo(self)
            make.height.equalTo(self)
        }
        
        self.btnFavi.snp.remakeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.center.equalToSuperview()
        }
    }
}
