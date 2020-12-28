//
//  BaseApiMgr.swift
//  Argus
//
//  Created by chris on 11/2/20.
//

import Foundation

import Alamofire
import SwiftyJSON

protocol BaseAPIRequestProtocol {
    static func sendRequest(_ url: String, _ method: HTTPMethod,
                            _ headers: [String: String],
                            _ params: [String: String],
                            _ success: @escaping ((_ resp: JSON) -> ()),
                            _ failure: @escaping ((_ error: String) -> ()))
}

class BaseAPIMgr: NSObject, BaseAPIRequestProtocol {
    class func hostURL(path: String) -> String {
        return "https://api.zhuishushenqi.com" + path
    }
    
    class func get(_ path: String,
                   _ params: [String: String],
                   _ success: @escaping ((_ resp: JSON) -> Void),
                   _ failure: @escaping ((_ error: String) -> Void)) {
        sendRequest(BaseAPIMgr.hostURL(path: path), .get, [:], params, { (object) in
                        success(object)
                    }, failure)
    }
    
    class func post(_ path: String, params: [String: String],
                    _ success: @escaping ((_ resp: JSON) -> Void),
                    _ failure: @escaping ((_ error: String) -> Void)) {
        sendRequest(path, .post, [:], params, { (object) in
                        success(object)
                    }, failure)
    }
    
    static func sendRequest(_ url: String, _ method: HTTPMethod,
                            _ headers: [String : String],
                            _ params: [String : String],
                            _ success: @escaping ((JSON) -> ()),
                            _ failure: @escaping ((String) -> ())) {
        
        let req: DataRequest = AF.request(url, method: method, parameters: params,
                                          encoding: URLEncoding.default, headers: HTTPHeaders.init(headers))
        
        req.responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { resp in
            if resp.error != nil {
                failure(resp.error.debugDescription)
            } else {
                success(JSON(resp.value as Any))
            }
        }
        
        req.resume()
    }
}

class BaseApiSystem: NSObject, BaseAPIRequestProtocol {
    static func sendRequest(_ url: String, _ method: HTTPMethod,
                            _ headers: [String : String],
                            _ params: [String : String],
                            _ success: @escaping ((JSON) -> ()),
                            _ failure: @escaping ((String) -> ())) {
        var url = url
        var data: Data? = nil
        if method.rawValue == "GET" {
            url = url + (params.count > 0 ? "?" : "") + joinParameters(params)
        } else if method.rawValue == "POST" {
            if JSONSerialization.isValidJSONObject(params) {
                do {
                    data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                } catch {
                    print("parameter json serialize error")
                }
            }
        }
        
        let path: URL = URL.init(string: url)!
        let config: URLSessionConfiguration = URLSessionConfiguration.default;
        let session: URLSession = URLSession.init(configuration: config)
        var req = URLRequest.init(url: path)
        req.httpMethod = method.rawValue
        req.timeoutInterval = 10
        req.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.addValue("chrome", forHTTPHeaderField: "User-Agent")
        
        if data != nil {
            req.httpBody = data
        }
        
        let task: URLSessionDataTask = session.dataTask(with: req) { (datas, resp, error) in
            DispatchQueue.main.sync {
                do {
                    if error != nil {
                        failure(error.debugDescription)
                    } else {
                        let json = try JSONSerialization.jsonObject(with: datas!, options: .mutableContainers)
                        success(JSON(json))
                    }
                } catch {
                    print("system network error")
                }
            }
        }
        task.resume()
    }
    
    class func joinParameters(_ parameters: [String: String]) -> String {
        var listData: [String] = [];
        parameters.forEach( {(key, val) in
            if key.count > 0 && val.count > 0 {
                listData.append(key + "=" + val)
            }
        })
        return listData.joined(separator: "&")
    }
}
