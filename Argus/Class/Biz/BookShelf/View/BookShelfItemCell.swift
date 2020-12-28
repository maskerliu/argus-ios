//
//  BookItemCell.swift
//  Argus
//
//  Created by chris on 11/18/20.
//

import Foundation

class BookShelfItemCell: UICollectionViewCell {
    lazy var ivCover: UIImageView = {
        let iv = UIImageView()
        iv.isSkeletonable = true
        iv.skeletonCornerRadius = 5
        iv.backgroundColor = UIColor(hex: "afafaf")
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    lazy var lTitle: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var lCategory: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var lState: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.layer.cornerRadius = 5
        label.layer.backgroundColor = UIColor(hex: "#888888", alpha: 0.8).cgColor
        return label
    }()
    
    var model: BookInfo? {
        didSet {
            guard let item = model else { return }
            
            hideSkeleton()
            
            var str : String = "";
            if item.cover!.hasPrefix("/agent/") {
                str = item.cover!.replacingOccurrences(of: "/agent/", with: "");
            }
            str = str.removingPercentEncoding ?? str;
            self.ivCover.kf.setImage(with: URL.init(string: str), placeholder: placeholder)
            
            self.lState.text = item.minorCate
            self.lTitle.text = item.title
            self.lCategory.text = item.majorCate
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(self.ivCover)
        contentView.addSubview(self.lTitle)
        contentView.addSubview(self.lCategory)
        contentView.addSubview(self.lState)
        
        isSkeletonable = true
        showSkeleton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    
    private func layout() {
        ivCover.snp.makeConstraints { make in
            make.height.equalTo(contentView.frame.size.height - 50)
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
        lTitle.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.centerX.equalTo(contentView)
            make.top.equalTo(self.ivCover.snp.bottom).offset(5)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
        lCategory.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.centerX.equalTo(contentView)
            make.top.equalTo(self.lTitle.snp.bottom).offset(5)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
        lState.snp.remakeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 15))
            make.top.equalTo(self.ivCover).offset(5)
            make.left.equalTo(self.ivCover).offset(5)
        }
    }
}
