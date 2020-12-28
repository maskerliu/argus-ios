//
//  StoreCategoryItemCell.swift
//  Argus
//
//  Created by chris on 11/12/20.
//

import SkeletonView

class StoreCategoryItemCell: UICollectionViewCell {
    
    lazy var ivCover: UIImageView = {
        let iv = UIImageView()
        iv.isSkeletonable = true
        iv.skeletonCornerRadius = 5
        iv.backgroundColor = UIColor(hex: "#afafaf")
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    lazy var lTitle: UILabel! = {
        let label = UILabel()
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    var model: BookClassify? {
        didSet {
            guard let item = model else { return }
            
            hideSkeleton()
            
            self.lTitle.text = item.title
            var str : String = item.bookCover?.first ?? "";
            if str.hasPrefix("/agent/") {
                str = str.replacingOccurrences(of: "/agent/", with: "")
            }
            str = str.removingPercentEncoding ?? str;
            self.ivCover.kf.setImage(with: URL.init(string: str), placeholder: placeholder)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(self.ivCover)
        contentView.addSubview(self.lTitle)
        
        layout()
        
        isSkeletonable = true
        showSkeleton()
    }
    
    private func layout() {
        ivCover.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.height.equalTo(contentView.frame.size.height - 30)
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)
        }
        
        lTitle.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.height.equalTo(17)
            make.centerX.equalTo(contentView)
            make.top.equalTo(self.ivCover.snp.bottom).offset(5)
        }
    }
}
