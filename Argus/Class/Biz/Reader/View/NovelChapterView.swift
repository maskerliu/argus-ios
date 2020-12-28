//
//  NovelChapterView.swift
//  Argus
//
//  Created by chris on 11/28/20.
//

import Foundation

@objc protocol NovelChapterDelegate: NSObjectProtocol {
    
    @objc optional func selectChapter(_ view: NovelChapterView, chapter: NSInteger)
    
}

class NovelChapterView: UIView {
    
    weak var delegate: NovelChapterDelegate!
    
    var chapter: NovelChapter!
    
    lazy var listData: [NovelChapter] = { return [] }()
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 60
        view.keyboardDismissMode = .onDrag
        view.separatorStyle = .none
        view.allowsSelection = true
        view.showsVerticalScrollIndicator = false
        view.isUserInteractionEnabled = true
        view.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        view.backgroundColor = Appxf8f8f8
        view.backgroundView?.backgroundColor = Appxf8f8f8
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true;
        addSubview(self.tableView);
        
        tableView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview();
            make.width.equalTo(SCREEN_WIDTH * 0.7);
        }
    }
    
    func setDatas(listData: [NovelChapter]) {
        self.listData.removeAll();
        self.listData.append(contentsOf: listData);
        self.tableView.reloadData();
    }
}

extension NovelChapterView: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NovelChapterItemCell.cellForTableView(tableView: tableView, indexPath: indexPath);
        let model: NovelChapter = self.listData[indexPath.row];
        cell.ivStatus.isHidden = !model.isVip;
        cell.lTitle.text = model.title;
        return cell;
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.delegate != nil {
            delegate?.selectChapter?(self, chapter: indexPath.row)
        }
    }
   
}
