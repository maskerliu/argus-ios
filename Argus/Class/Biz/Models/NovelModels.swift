//
//  NovelModels.swift
//  Argus
//
//  Created by chris on 11/2/20.
//

import HandyJSON

public enum NovelTheme: String, HandyJSONEnum {
    case defaults = "bg_default"
    case green = "bg_green"
    case caffee = "bg_coffee"
    case yellow = "bg_yellow"
    case black = "bg_black"
}

public enum NovelBrowse: Int, HandyJSONEnum {
    case defaults = 0
    case pageCurl = 1
    case none = 2
    case scroll = 3
}

public class NovelSet: HandyJSON {
    var color: String = "333333"
    var fontName: String = "PingFang-SC-Regular"
    var fontSize: Float = 18
    var lineSpacing: Float = 5
    var firstLineHeadIndent: Float = 20
    var paragraphSpacingBefore: Float = 5
    var paragraphSpacing: Float = 5
    var brightness: Float = 0
    
    var night: Bool = false
    var landscape: Bool = false
    var tradition: Bool = false
    
    var skin: NovelTheme = .defaults
    var browse: NovelBrowse = .defaults
    
    required public init() {}
}

class NovelChapterInfo: HandyJSON {
    var _id: String = ""
    var source: String = ""
    var updated: String = ""
    var book: String = ""
    var starting: String = ""
    var link: String = ""
    var host: String = ""
    var name: String = ""
    
    var chapters: [NovelChapter] = []
    
    required public init() {}
}

class NovelChapter: HandyJSON {
    var bookId: String = ""
    var chapterId: String = ""
    var chapterCover: String = ""
    var link: String = ""
    var time: String = ""
    var title: String = ""
    
    var isVip: Bool = false
    var order: Int = 0
    var chapterIdx: Int = 0
    var partSize: Int = 0
    var totalPage: Int = 0
    var currency: Int = 0
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.chapterId <-- ["chapterId", "id"]
    }
    
    var content: NovelContent? {
        get {
            let json = AGCache.get(self.chapterId)
            if let info = NovelContent.deserialize(from: json.rawString()) {
                return info
            }
            
            return NovelContent()
        }
    }
}

class NovelContent: HandyJSON {
    var bookId: String = ""
    var chapterId: String = ""
    var title: String = ""
    var content: String = ""
    var traditial: String = ""
    var created: String = ""
    var updated: String = ""
    
    var isVip: Bool = false
    var position: Float = 0.0
    var pageIdx: Int = 0
    var pageCount: Int = 0
    
    private lazy var pageArray: [Int] = {
        return []
    }()
    
    private lazy var attributedString: NSAttributedString = {
        return NSAttributedString.init()
    }()
    
    private var lineCount: String? {
        get {
            var content: String = self.content
            content = content.replacingOccurrences(of: "\n\r", with: "\n")
            content = content.replacingOccurrences(of: "\r\n", with: "\n")
            content = content.replacingOccurrences(of: "\n\n", with: "\n")
            content = content.replacingOccurrences(of: "\t\n", with: "\n")
            content = content.replacingOccurrences(of: "\t\t", with: "\n")
            content = content.replacingOccurrences(of: "\n\n", with: "\n")
            content = content.replacingOccurrences(of: "\r\r", with: "\n")
            content = content.trimmingCharacters(in: .whitespacesAndNewlines)
            content = self.removeLine(content: content);
            return content
        }
    }
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.chapterId <-- ["bookId", "id"]
        mapper <<< self.content <-- ["cpContent", "body", "content"]
    }
    
    func pageContent() {
        self.pageBound(bound: AppFrame)
    }
    
    public func attrContent(page: NSInteger) -> NSAttributedString {
        if self.pageArray.count == 0 {
            return NSAttributedString.init(string: "空空如野")
        }
        
        let idx = (page > self.pageArray.count) ? self.pageArray.count - 1 : page
        let loc: Int = self.pageArray[idx]
        var len: Int = 0
        if idx == (self.pageArray.count - 1) {
            len = self.attributedString.length - loc
        } else {
            len = self.pageArray[idx + 1] - loc
        }
        
        return self.attributedString.attributedSubstring(from: NSRange.init(location: loc, length: len))
    }
    
    private func pageBound(bound: CGRect) {
        self.pageArray.removeAll()
        
        let content: String = self.lineCount ?? ""
        let attr :NSMutableAttributedString = NSMutableAttributedString.init(string: content, attributes: (NovelSettingService.defaultFont() ))
        let frameSetter :CTFramesetter = CTFramesetterCreateWithAttributedString(attr);
        let path :CGPath = CGPath(rect: bound,transform: nil)
        var range: CFRange = CFRangeMake(0, 0)
        var rangeOffset: Int = 0
        while range.location + range.length < attr.length {
            let frame :CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil);
            range = CTFrameGetVisibleStringRange(frame);
            rangeOffset += range.length;
            self.pageArray.append(range.location)
        }
        self.pageCount = self.pageArray.count
        self.attributedString = attr
    }
    
    private func removeLine(content: String) -> String {
        var datas: NSArray = content.components(separatedBy: CharacterSet.newlines) as NSArray
        let pre = NSPredicate.init(format: "self <> ''")
        datas = datas.filtered(using: pre) as NSArray
        var list: [String] = []
        datas.forEach { (obj) in
            var str = obj as! String
            str = str.trimmingCharacters(in: .whitespacesAndNewlines)
            list.append(str)
        }
        return list.joined(separator: "\n")
    }
}

public class NovelSource: HandyJSON {
    var sourceId: String? = ""
    var chaptersCount: Int? = 0;
    var host: String? = "";
    var isCharge: Bool? = false;
    var lastChapter: String? = "";
    var link: String? = "";
    var name: String? = "";
    var source: String? = "";
    var starting: String? = "";
    var updated: String? = "";
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<< self.sourceId <-- ["sourceId","_id"]
    }
    
    required public init() {}
}
