//
//  MyTableViewCells.swift
//  Argus
//
//  Created by chris on 11/6/20.
//

import UIKit
import SnapKit

class MyTableViewCell: UITableViewCell {
    lazy var ivArrow: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon_arrow_right"))
        return iv
    }()
    
    lazy var btnSwitch: UISwitch = { return UISwitch() }()
    
    lazy var lTitle: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    var lSubTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.gray
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    lazy var ivIcon: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    lazy var dividing: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "444444")
        return view
    }()
    
    var model: MyItemModel? {
        didSet {
            guard let item = model else { return }
            
            self.lTitle.text = item.title
            self.lSubTitle.text = item.subTitle
            self.ivIcon.image = UIImage(named: item.icon)
            let theme = AppThemeService.mgr.theme
            self.btnSwitch.isHidden = true
            self.btnSwitch.isOn = theme?.state == .day
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(self.ivArrow)
        contentView.addSubview(self.btnSwitch)
        contentView.addSubview(self.lTitle)
        contentView.addSubview(self.lSubTitle)
        contentView.addSubview(self.ivIcon)
        contentView.addSubview(self.dividing)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        
        self.ivIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(15)
        }
        
        self.lTitle.snp.makeConstraints { make in
            make.centerY.equalTo(contentView).offset(-8)
            make.left.equalTo(self.ivIcon.snp.right).offset(15)
        }
        
        self.lSubTitle.snp.makeConstraints { make in
            make.top.equalTo(lTitle.snp.bottom).offset(5)
            make.left.right.equalTo(lTitle)
        }
        
        self.btnSwitch.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-35)
            make.centerY.equalTo(contentView)
        }
        
        self.ivArrow.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 14, height: 20))
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15)
        }
        
        self.dividing.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: self.frame.width - 15, height: 0.5))
            make.left.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView)
        }
    }
    
    func changeAction(_ sender: UISwitch) {
        let theme = AppThemeService.mgr.theme
        if theme?.state == .day {
            AppThemeService.setState(state: .night)
        } else {
            AppThemeService.setState(state: .day)
        }
    }
}
