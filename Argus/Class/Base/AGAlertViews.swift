//
//  AGAlertViews.swift
//  Argus
//
//  Created by chris on 11/10/20.
//

import Foundation


class AGAlertViews: NSObject {
    
    
    class func showAlertView(title:String? = nil,message:String? = nil,normals:NSArray? = nil,hights:NSArray? = nil,completion: @escaping ((_ title:String,_ index :NSInteger) -> Void)){
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert);
        if normals != nil{
            for (index,object) in normals!.enumerated() {
                let action = UIAlertAction.init(title:(object as! String), style: .cancel) { (alert) in
                    completion(object as! String,index);
                };
                alertView.addAction(action);
            }
        }
        if hights != nil {
            for (index,sure) in hights!.enumerated() {
                let action = UIAlertAction.init(title:(sure as! String), style: .destructive) { (alert) in
                    completion(sure as! String,index + (normals != nil ? normals!.count : 0));
                };
                alertView.addAction(action);
            }
        }
        let rootVC = UIViewController.rootTopPresentedController();
        rootVC.present(alertView, animated:true, completion: nil);
    }
    
    
}
