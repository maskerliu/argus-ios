//
//  StoreBookDetailHeaderView.swift
//  Argus
//
//  Created by chris on 11/16/20.
//

import SkeletonView

class StoreBookDetailHeaderView: UIView {
    
    lazy var ivBg: UIImageView = {
        var iv: UIImageView = UIImageView();
        return iv;
    }()
    
    lazy var ivCover: UIImageView = {
        let iv = UIImageView()
        iv.isSkeletonable = true
        iv.skeletonCornerRadius = 5
        return iv
    }()
    
    lazy var lTitle: UILabel = {
        let label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var lSubTitle: UILabel = {
        let label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var lChapter: UILabel = {
        let label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var lCount: UILabel = {
        let label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var lAuthor: UILabel = {
        let label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#3498db")
        label.numberOfLines = 1
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var lFollow: UILabel = {
        let label = UILabel()
        label.text = " "
        label.isSkeletonable = true
        label.skeletonCornerRadius = 5
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.layer.cornerRadius = 7.0
        label.layer.backgroundColor = UIColor.white.cgColor
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    lazy var btnBack: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 10, y: 20, width: 44, height: 44)
        btn.setImage(UIImage(named: "icon_navi_back"), for: .normal)
        return btn
    }()
    
    var model: BookDetail? {
        didSet {
            guard let item = model else { return }
            
            hideSkeleton()
            
            var str : String = "";
            if item.cover!.hasPrefix("/agent/") {
                str = item.cover!.replacingOccurrences(of: "/agent/", with: "");
            }
            str = str.removingPercentEncoding ?? str;
            self.ivCover.kf.setImage(with: URL.init(string: str), placeholder: placeholder)
            self.ivBg.kf.setImage(with: URL.init(string: str), placeholder: placeholder)
            self.lTitle.text = item.title! + (!item.isSerial! ? "(完结)" : "(连载)");
            self.lSubTitle.text =  "最新章节：" + item.lstChapter! ;
            self.lAuthor.text = item.author ?? "";
            self.lCount.text = "字数：" + String(item.wordCount ?? 0);
            self.lChapter.text = "章节数：" + String(item.chaptersCount ?? "0");
            self.lFollow.text = "关注度 " + String(item.retentionRatio) + "%"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.ivBg)
        addSubview(self.ivCover)
        addSubview(self.lTitle)
        addSubview(self.lSubTitle)
        addSubview(self.lChapter)
        addSubview(self.lCount)
        addSubview(self.lAuthor)
        addSubview(self.lFollow)
        addSubview(self.btnBack)
        
        self.ivBg.layer.masksToBounds = true
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.ivBg.addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        
        isSkeletonable = true
        showSkeleton()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
                
        btnBack.snp.remakeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(10)
        }
        
        ivBg.snp.remakeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        ivCover.snp.remakeConstraints { make in
            make.top.equalTo(self.btnBack.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(ivCover.frame.size.height / 1.35)
        }
        
        lTitle.snp.remakeConstraints { make in
            make.top.equalTo(self.ivCover)
            make.left.equalTo(self.ivCover.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
        
        lSubTitle.snp.remakeConstraints { make in
            make.top.equalTo(self.lTitle.snp.bottom).offset(10)
            make.left.equalTo(self.lTitle)
            make.right.equalToSuperview().offset(-15)
        }
        
        lChapter.snp.remakeConstraints { make in
            make.top.equalTo(self.lSubTitle.snp.bottom).offset(10)
            make.left.equalTo(self.lTitle)
            make.right.equalToSuperview().offset(-45)
        }
        
        lCount.snp.remakeConstraints { make in
            make.top.equalTo(self.lChapter.snp.bottom).offset(10)
            make.left.equalTo(self.lTitle)
            make.right.equalToSuperview().offset(-45)
        }
        
        lAuthor.snp.remakeConstraints { make in
            make.width.equalTo(50)
            make.bottom.equalTo(self.ivCover)
            make.left.equalTo(self.lTitle)
        }
        
        lFollow.snp.remakeConstraints { make in
            make.width.equalTo(90)
            make.bottom.equalTo(self.ivCover)
            make.right.equalToSuperview().offset(-15)
        }
        
    }
    
}
