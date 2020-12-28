//
//  SocketClient.swift
//  Argus
//
//  Created by chris on 12/15/20.
//

import Foundation

import Starscream
import SwiftyJSON
import RealmSwift

public typealias RequestCompletion = (JSON?, Bool) -> Void
public typealias VoidCompletion = () -> Void
public typealias MessageCompletion = (SocketResponse) -> Void
public typealias SocketCompletion = (WebSocket?, Bool) -> Void
public typealias MessageCompletionObject<T: Object> = (T?) -> Void
public typealias MessageCompletionObjectList<T: Object> = ([T]) -> Void


enum SocketConnectionState {
    case connected
    case connecting
    case disconnected
    case waitingForNetwork
}

protocol SocketConnectionHandler {
    func socketDidChangeState(state: SocketConnectionState)
}

final class SocketClient {
    
    static let instance = SocketClient()
    
    var serverURL: URL?
    var socket: WebSocket?
    var queue: [String: MessageCompletion] = [:]
    var events: [String: [MessageCompletion]] = [:]
    
    internal var internalConnectionHandler: SocketCompletion?
    internal var connectionHandlers = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
    internal var isPresentingInvalidSessionAlert = false
    
    var state: SocketConnectionState = .disconnected {
        didSet {
            if let enumerator = connectionHandlers.objectEnumerator() {
                while let handler = enumerator.nextObject() {
                    if let handler = handler as? SocketConnectionHandler {
                        handler.socketDidChangeState(state: state)
                    }
                }
            }
        }
    }
    
    
    
}


extension SocketClient {
    
    static func reconnect() {
        
        instance.state = .connecting
        let curRealm = Realm.current
    }
    
    static func isConnected() -> Bool {
        return self.instance.socket?.isConnected ?? false
    }
}
