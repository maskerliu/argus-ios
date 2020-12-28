//
//  StoreBookDetailVC.swift
//  Argus
//
//  Created by chris on 11/16/20.
//

import RxSwift
import RxCocoa

class StoreBookDetailVC: BaseVC {
    
    let bag = DisposeBag()
    
    class func vcWithBookId(_ bookId: String) -> Self {
        let vc = StoreBookDetailVC()
        vc.bookId = bookId
        return vc as! Self
    }
    
    lazy var header: StoreBookDetailHeaderView = {
        let view = StoreBookDetailHeaderView(frame: .zero)
        view.btnBack.rx.tap.subscribe(onNext: { [weak self] in
            self?.back(animated: true)
        }).disposed(by: bag)
        
        return view
    }()
    
    lazy var sg: UISegmentedControl = {
        let titles = ["推荐", "章节"]
        let sg = UISegmentedControl(items: titles)
        sg.selectedSegmentIndex = 0
        sg.addTarget(self, action: #selector(sgChanged), for: .valueChanged)
        
//        sg.rx.value.asObservable().subscribe(onNext: { _ in
//            self.sgChanged()
//        }).disposed(by: bag)
        return sg
    }()
    
    
    lazy var descVC: BookDetailDescVC = {
        let vc = BookDetailDescVC(bookId: bookId)
        return vc
    }()
    
    lazy var chapterVC: BookDetailChaptersVC = {
        let vc = BookDetailChaptersVC.vcWithBookId(bookId)
        return vc
    }()
    
    lazy var footer: StoreBookDetailFooterView = {
        let view = StoreBookDetailFooterView(frame: .zero)
        view.frame.size.height = 50
        view.btnRead.rx.tap.subscribe(onNext: { [weak self] in
            self?.readNovel()
        }).disposed(by: bag)
        return view
    }()
    
    private var bookId: String! = nil
    private var model: BookDetail? {
        didSet {
            guard let item = model else { return }
            self.header.model = item
            self.descVC.model = item
            self.chapterVC.model = item
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.header)
        view.addSubview(self.footer)
        view.addSubview(self.sg)
        addChild(self.descVC)
        addChild(self.chapterVC)
        
        if self.sg.selectedSegmentIndex == 0 {
            view.addSubview(self.descVC.view)
        } else {
            view.addSubview(self.chapterVC.view)
        }
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func layout() {
        header.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(250)
        }
        
        footer.snp.makeConstraints { make in
            make.width.equalTo(view)
            make.height.equalTo(49)
            make.bottom.equalToSuperview().offset(-TAB_BAR_ADDING);
        }
        
        sg.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        if self.sg.selectedSegmentIndex == 0 {
            descVC.view.snp.remakeConstraints { make in
                make.width.equalTo(view)
                make.top.equalTo(self.sg.snp.bottom).offset(10)
                make.bottom.equalTo(self.footer.snp.top)
            }
        } else {
            chapterVC.view.snp.remakeConstraints { make in
                make.width.equalTo(view)
                make.top.equalTo(self.sg.snp.bottom).offset(10)
                make.bottom.equalTo(self.footer.snp.top)
            }
        }
    }
    
    private func loadData() {
        BizStoreAPIs.bookDetail(self.bookId) { resp in
            if let model = BookDetail.deserialize(from: resp.rawString()) {
                self.model = model
            }
        } failure: { (error) in
            
        }
    }
    
    @objc private func sgChanged() {
        switch self.sg.selectedSegmentIndex {
        case 1:
            view.addSubview(self.chapterVC.view)
            transition(from: self.descVC, to: self.chapterVC, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
        default:
            view.addSubview(self.descVC.view)
            transition(from: self.chapterVC, to: self.descVC, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
        }
    }
    
    private func readNovel() {
        if self.model != nil {
            if let model = BookInfo.deserialize(from: self.model!.toJSONString()) {
                AGRouter.jumpToNovel(book: model, chapter: 0, pageIndex: 0)
            }
        }
    }
}
