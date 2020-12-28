//
//  UICollectionViewCell+Extension.swift
//  Argus
//
//  Created by chris on 11/5/20.
//

import UIKit

public extension UIView {
    class func xibName() -> String {
        let name = NSStringFromClass(self.classForCoder())
        let datas: [String] = name.components(separatedBy: ".")
        return datas.count > 0 ? datas.last! : ""
    }
    
    class func instanceView() -> Self {
        let nib = Bundle.main.url(forResource: self.xibName(), withExtension: "nib")
        if nib != nil {
            let view = Bundle.main.loadNibNamed(self.xibName(), owner: self, options: nil)?.first
            return view as! Self
        }
        return self.init()
    }
}

extension UITableViewCell {
    static var confiTag: Int = 32241983
    
    class func cellForTableView(tableView: UITableView, indexPath: IndexPath) ->Self{
       return self.cellForTableView(tableView: tableView, indexPath: indexPath, identifier: nil, config: nil)
    }
    
    class func cellForTableView(tableView: UITableView, indexPath: IndexPath, identifier: String? = nil, config:((_ cell : UITableViewCell) ->Void)? = nil) ->Self {
        let identy: String = identifier != nil ? identifier! : NSStringFromClass(self.classForCoder())
        var cell = tableView.dequeueReusableCell(withIdentifier: identy)
        
        if cell == nil {
            let nib =  Bundle.main.url(forResource:self.xibName(), withExtension:"nib")
            if (nib != nil) {
                tableView.register(UINib.init(nibName:self.xibName(), bundle:nil), forCellReuseIdentifier: identy)
            } else {
                tableView.register(self.classForCoder(), forCellReuseIdentifier: identy)
            }
            cell = tableView.dequeueReusableCell(withIdentifier:identy)
        }
        
        if cell?.tag != confiTag {
            cell?.tag = confiTag
            if (config != nil) {
                config!(cell!)
            }
        }
        return cell as! Self
    }
}

public extension UICollectionViewCell {
    
//    static var configTag: Int = 32241981
    
    class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        return self.cellForCollectionView(collectionView: collectionView, indexPath: indexPath, identifier: nil, config: nil)
    }
    
    class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath, identifier: String? = nil, config: ((_ cell: UICollectionViewCell) -> Void)? = nil) -> Self {
        let id = identifier ?? NSStringFromClass(self.classForCoder())
        var res1: Bool = false, res2: Bool = false
        if collectionView.value(forKeyPath: "cellNibDict") != nil {
            let dict1 = (collectionView.value(forKeyPath: "cellNibDict") as? NSDictionary)!
            res1 = dict1.value(forKeyPath: id) != nil
        }
        
        if collectionView.value(forKeyPath: "cellClassDict") != nil {
            let dict2 = (collectionView.value(forKeyPath: "cellClassDict") as? NSDictionary)!
            res2 = dict2.value(forKeyPath: id) != nil
        }
        
        let hasRegister = res1 || res2
        if !hasRegister {
            let nib = Bundle.main.url(forResource: self.xibName(), withExtension: "nib")
            if nib != nil {
                collectionView.register(UINib.init(nibName: self.xibName(), bundle: nil), forCellWithReuseIdentifier: id)
            } else {
                collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: id)
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        if cell.tag != configTag {
            cell.tag = configTag
            if config != nil {
                config!(cell)
            }
        }
        return cell as! Self
    }
}

public extension UICollectionReusableView {
    
    static var configTag: Int = 32241982
    
    class func viewForCollectionView(collectionView: UICollectionView, elementKind: String, indexPath: IndexPath) -> Self {
        return self.viewForCollectionView(collectionView: collectionView,
                                          elementKind: elementKind,
                                          indexPath: indexPath,
                                          identifier: nil,
                                          config: nil)
    }
    
    class func viewForCollectionView(collectionView: UICollectionView,
                                     elementKind: String,
                                     indexPath:IndexPath,
                                     identifier: String? = nil,
                                     config: ((_ cell :UICollectionReusableView) ->Void)? = nil) ->Self {
        assert(elementKind.count > 0)
        let identy : String = identifier != nil ? identifier! : NSStringFromClass(self.classForCoder())
        let keyPath = elementKind.appendingFormat("/" + identy)
        var res1 : Bool = false
        var res2 : Bool = false
        if  collectionView.value(forKeyPath:"supplementaryViewNibDict") != nil {
            let dic  = collectionView.value(forKeyPath:"supplementaryViewNibDict") as! NSDictionary
            res1 = dic.value(forKeyPath:keyPath) != nil ? true : false
        }
        if collectionView.value(forKeyPath: "supplementaryViewClassDict") != nil {
            let dic  = collectionView.value(forKeyPath:"supplementaryViewClassDict") as! NSDictionary
            res2 = dic.value(forKeyPath:keyPath) != nil ? true : false
        }
        let hasRegister = res1 || res2
        if hasRegister == false {
            let nib =  Bundle.main.url(forResource:self.xibName(), withExtension:"nib")
            if (nib != nil) {
                collectionView.register(UINib.init(nibName: self.xibName(), bundle:nil), forSupplementaryViewOfKind: elementKind, withReuseIdentifier:identy)
            }else{
                collectionView.register(self.classForCoder(), forSupplementaryViewOfKind: elementKind, withReuseIdentifier:identy)
            }
        }
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                                   withReuseIdentifier: identy,
                                                                   for: indexPath)
        if cell.tag != configTag{
            cell.tag = configTag
            if config != nil {
                config!(cell)
            }
        }
        return cell as! Self
    }
}
