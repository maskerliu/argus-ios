//
//  NovelSetCell.swift
//  Argus
//
//  Created by chris on 11/5/20.
//

import UIKit

class NovelSettingBGColorCell: UICollectionViewCell {
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        return view
    }()
    lazy var imageV: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.imageV)
        addSubview(self.icon)
        
        layout()
    }
    
    private func layout() {
        imageV.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.center.equalToSuperview()
        }
    }
}
