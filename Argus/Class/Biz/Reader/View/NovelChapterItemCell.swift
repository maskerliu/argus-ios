//
//  NovelChapterItemCell.swift
//  Argus
//
//  Created by chris on 11/16/20.
//

import UIKit

class NovelChapterItemCell: UITableViewCell {
    
    lazy var lTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var ivStatus: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon_status_lock"))
        return iv
    }()
    
    lazy var dividing: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#888888")
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.isUserInteractionEnabled = true
        
        contentView.addSubview(self.lTitle)
        contentView.addSubview(self.ivStatus)
        contentView.addSubview(self.dividing)
        
        layout()
    }
    
    
    
    private func layout() {
        
        lTitle.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-55)
            make.centerY.equalTo(contentView)
        }
        
        ivStatus.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
        }
        
        dividing.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(0.5)
            make.bottom.equalTo(contentView)
        }
    }
}
