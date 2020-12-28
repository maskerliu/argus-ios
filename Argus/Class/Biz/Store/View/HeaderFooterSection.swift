//
//  HeaderFooterSection.swift
//  Argus
//
//  Created by chris on 11/11/20.
//

import Foundation

class HeaderFooterSection: UITableViewHeaderFooterView {
    
    lazy var lTitle: UILabel = {
        let label = UILabel()
        
        label.text = "        "
        label.isSkeletonable = true
        label.linesCornerRadius = 5
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        isSkeletonable = true
        
        contentView.addSubview(lTitle)

        backgroundView = UIView()
        if #available(iOS 13.0, *) {
            backgroundView?.backgroundColor = .systemBackground
        } else {
            backgroundView?.backgroundColor = .white
        }
    }
    
    private func layout() {
        lTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        
    }
}
