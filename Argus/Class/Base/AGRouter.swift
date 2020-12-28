//
//  AGRouter.swift
//  Argus
//
//  Created by chris on 11/6/20.
//

//import Flutter


class AGRouter: NSObject {
    
     @objc class func window() -> UIWindow? {
        let app: UIApplication = UIApplication.shared
        if (app.delegate?.responds(to: #selector(window)))! {
            return ((app.delegate?.window)!)!
        }
        return app.keyWindow
    }
    
    class func jumpToFlutterVC() {
//        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
//        let vc = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
//        vc.hidesBottomBarWhenPushed = true
//        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    
    class func jumpToBrowse() {
        let vc = BrowseHistoryVC()
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    
    class func jumpToCategoryDetail(group: String, name: String) {
        let vc = StoreCategoryDetailVC(group: group, name: name)
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    
    class func jumpToBookDetail(bookId: String) {
        let vc = StoreBookDetailVC.vcWithBookId(bookId)
        vc.hidesBottomBarWhenPushed = true
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    
    class func jumpToNovel(book: BookInfo, chapter: NSInteger?, pageIndex: NSInteger?) {
        let vc = NovelContentVC(book: book)
        vc.chapter = chapter ?? 0
        vc.pageIdx = pageIndex ?? 0
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    
}
