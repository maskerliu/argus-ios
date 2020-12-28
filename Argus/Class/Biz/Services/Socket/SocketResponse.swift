//
//  SocketResponse.swift
//  Argus
//
//  Created by chris on 12/15/20.
//

import SwiftyJSON
import Starscream

enum ResponseMessage: String {
    case connected
    case error
    case ping
    case changed
    case added
    case inserted
    case updated
    case removed
    case unknown
}

public struct SocketResponse {
    var socket: WebSocket?
    var result: JSON
    
    var id: String?
    var msg: ResponseMessage?
    var collection: String?
    var event: String?
    
    init(_ result: JSON, socket: WebSocket?) {
        self.result = result
        self.socket = socket
        self.id = result["id"].string
        self.collection = result["collection"].string
        
        if let eventName = result["fields"]["eventName"].string {
            self.event = eventName
        }
        
        if let msg = result["msg"].string {
            self.msg = ResponseMessage(rawValue: msg) ?? ResponseMessage.unknown
            
            if self.msg == ResponseMessage.unknown {
                if self.isError() {
                    self.msg = ResponseMessage.error
                }
            }
        }
    }
    
    func isError() -> Bool {
        return msg == .error || result["error"] != JSON.null
    }
}
