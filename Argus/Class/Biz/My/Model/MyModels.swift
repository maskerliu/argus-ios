//
//  MyModel.swift
//  Argus
//
//  Created by chris on 11/6/20.
//

import HandyJSON

public class MyItemModel: HandyJSON {
    var icon: String = ""
    var title: String = ""
    var subTitle: String = ""
    
    class func vcWithModel(icon: String, title: String, subTitle: String) -> Self {
        let model = MyItemModel()
        model.icon = icon
        model.title = title
        model.subTitle = subTitle
        return model as! Self
    }
    
    required public init() {}
}
