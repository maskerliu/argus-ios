//
//  NovelReaderView.swift
//  Argus
//
//  Created by chris on 11/26/20.
//

class NovelReaderView: UIView {
    var contentFrame :CTFrame!
    
    var content :NSAttributedString = NSAttributedString.init(string: ""){
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super .layoutSubviews();
        let setterRef = CTFramesetterCreateWithAttributedString(self.content)
        let pathRef = CGPath(rect: self.bounds,transform: nil)
        let frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, nil)
        self.contentFrame = frameRef;
    }
    
    override func draw(_ rect: CGRect) {
        if self.contentFrame == nil {
            return
        }
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.textMatrix = .identity;
        ctx.translateBy(x: 0, y: self.bounds.height)
        ctx.scaleBy(x: 1, y: -1)
        CTFrameDraw(self.contentFrame, ctx)
    }
    
}
