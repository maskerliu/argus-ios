//
//  StoreBookItemCell.swift
//  Argus
//
//  Created by chris on 11/11/20.
//

import Foundation

class StoreBookItemCell: UITableViewCell {
    
    lazy var ivCover: UIImageView = {
        var iv = UIImageView()
        iv.isSkeletonable = true
        iv.skeletonCornerRadius = 5
        iv.backgroundColor = UIColor(hex: "afafaf")
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    lazy var lTitle: UILabel = {
        var label = UILabel()
        label.text = "     "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var lSubTitle: UILabel = {
        var label = UILabel()
        label.isSkeletonable = true
        label.text = "  "
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = UIColor.gray
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    lazy var lFollowCount: UILabel = {
        var label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor.gray
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    lazy var lState: UILabel = {
        let label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.layer.backgroundColor = UIColor(hex: "#888888", alpha: 0.8).cgColor
        label.layer.cornerRadius = 7.0
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    lazy var lFollow: UILabel = {
        let label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.layer.backgroundColor = UIColor(hex: "#888888", alpha: 0.6).cgColor
        label.layer.cornerRadius = 7.0
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    lazy var lAuthor: UILabel = {
        let label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.layer.backgroundColor = UIColor(hex: "#888888", alpha: 0.6).cgColor
        label.layer.cornerRadius = 7.0
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    lazy var dividing: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#888888")
        return view
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
        
            self.lTitle.text = item.title ?? ""
            self.lSubTitle.attributedText  = titleAttr(content: item.shortIntro ?? "")
            self.lFollowCount.text = String(item.latelyFollower ?? 0)
            self.lState.text = item.majorCate ?? ""
            self.lState.isHidden = item.majorCate?.count == 0 ? true : false
            self.lFollow.text = "关注:" + String(item.retentionRatio) + ("%")
            self.lAuthor.text = item.author ?? ""
            self.lAuthor.isHidden = item.author!.count > 0 ? false : true
        
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(self.ivCover)
        contentView.addSubview(self.lTitle)
        contentView.addSubview(self.lSubTitle)
        contentView.addSubview(self.lFollowCount)
        contentView.addSubview(self.lAuthor)
        contentView.addSubview(self.lFollow)
        contentView.addSubview(self.lState)
        contentView.addSubview(self.dividing)
        
        isSkeletonable = true
        showSkeleton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    
    private func layout() {
        
        ivCover.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(ivCover.frame.size.height / 1.35)
        }
        
        lTitle.snp.remakeConstraints { make in
            make.top.equalTo(self.ivCover)
            make.left.equalTo(self.ivCover.snp.right).offset(15)
            make.right.equalToSuperview().offset(-105)
        }
        
        lSubTitle.snp.remakeConstraints { make in
            make.top.equalTo(self.lTitle.snp.bottom).offset(5)
            make.left.equalTo(self.ivCover.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        lFollowCount.snp.remakeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 17))
            make.top.equalTo(self.lTitle)
            make.right.equalToSuperview().offset(-15)
        }
        
        lState.snp.remakeConstraints { make in
            make.width.equalTo(40)
            make.top.equalTo(ivCover).offset(6)
            make.left.equalTo(ivCover).offset(6)
        }
        
        lAuthor.snp.remakeConstraints { make in
            make.width.equalTo(65)
            make.left.equalTo(self.lTitle)
            make.bottom.equalTo(self.ivCover.snp.bottom)
        }
        
        lFollow.snp.remakeConstraints { make in
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(self.ivCover.snp.bottom)
        }
        
        dividing.snp.remakeConstraints { make in
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func titleAttr(content :String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byTruncatingTail
        style.lineSpacing = 4
        style.alignment = .left
        style.allowsDefaultTighteningForTruncation = true
        return NSAttributedString(string:content.count > 0 ? content : "这家伙很懒,暂无简介!", attributes:[NSAttributedString.Key.paragraphStyle : style])
   }
    
}
