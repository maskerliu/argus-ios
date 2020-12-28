//
//  StoreBookDetailIntroView.swift
//  Argus
//
//  Created by chris on 11/25/20.
//

import Foundation

private let view: StoreBookDetailIntroView = StoreBookDetailIntroView.instanceView()

class StoreBookDetailIntroView: UICollectionReusableView {
    
    lazy var btnMore: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var lContent: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var constraintHeight: NSLayoutConstraint = NSLayoutConstraint()
    
    var content: String? {
        didSet {
            guard let content = content else { return }
            
            self.lContent.attributedText = contentAttr(content)
            let height = contentHeight(0)
            let height3 = contentHeight(3)
            
            self.btnMore.isHidden = height <= height3
            self.constraintHeight.constant = self.btnMore.isHidden ? 0.001 : 30
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.lContent)
        addSubview(self.btnMore)
    }
    
    class func getHeight(model: BookDetail) -> CGFloat {
        view.lContent.numberOfLines = model.numberLine
        view.content = model.shortIntro
        
        let cont: NSLayoutConstraint = NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: SCREEN_WIDTH)
        view.addConstraint(cont)
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        view.removeConstraint(cont)
        return height
    }
    
    func contentAttr(_ data: String) -> NSAttributedString {
        let content = data.trimmingCharacters(in: .whitespacesAndNewlines)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .left
        paragraphStyle.allowsDefaultTighteningForTruncation = true
        return NSAttributedString(string: content.count > 0 ? content : "这家伙很懒,暂无简介!",
                                  attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
    }
    
    func contentHeight(_ line: Int) -> CGFloat {
        let lTitle = UILabel()
        lTitle.attributedText = contentAttr(self.content ?? "")
        lTitle.numberOfLines = line
        lTitle.preferredMaxLayoutWidth = SCREEN_WIDTH - 20
        return lTitle.sizeThatFits(CGSize(width: lTitle.preferredMaxLayoutWidth, height: SCREEN_HEIGHT)).height
    }
}
