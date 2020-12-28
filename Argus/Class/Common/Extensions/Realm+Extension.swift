//
//  Realm+Extension.swift
//  Argus
//
//  Created by chris on 12/15/20.
//

import RealmSwift

var realmConfiguration: Realm.Configuration?
let realmTestingConfiguration = Realm.Configuration(
    inMemoryIdentifier: "realm-testing-identifier",
    deleteRealmIfMigrationNeeded: true
)

extension Realm {
    
    #if TEST
    static var current: Realm? {
        return try? Realm(configuration: realmTestingConfiguration)
    }
    #endif
    
    #if !TEST
    static var current: Realm? {
        if let configuration = realmConfiguration {
            return try? Realm(configuration: configuration)
        } else {
            let configuration = Realm.Configuration(
                deleteRealmIfMigrationNeeded: true
            )

            return try? Realm(configuration: configuration)
        }
    }
    #endif
}

extension Realm {
    static let writeQueue = DispatchQueue(label: "com.github.lynxchina.argus.realm.write", qos: .background)
    
    #if TEST
    func execute(_ execution: @escaping (Realm) -> Void, completion: VoidCompletion? = nil) {
        if isInWriteTransaction {
            execution(self)
        } else {
            try? write {
                execution(self)
            }
        }
        
        completion?()
    }
    
    #endif
    
    #if !TEST
    func execute(_ execution: @escaping (Realm) -> Void, completion: VoidCompletion? = nil) {
        var bgTaskId: UIBackgroundTaskIdentifier?
        bgTaskId = UIApplication.shared.beginBackgroundTask(withName: "com.github.lynxchina.argus.realm.background") {
            bgTaskId = UIBackgroundTaskIdentifier.invalid
        }
        
        if let bgTaskId = bgTaskId {
            let config = self.configuration
            
            Realm.writeQueue.async {
                if let realm = try? Realm(configuration: config) {
                    try? realm.write {
                        execution(realm)
                    }
                }
                
                if let completion = completion {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
                
                UIApplication.shared.endBackgroundTask(bgTaskId)
            }
        }
    }
    #endif
    
    static func execute(_ execution: @escaping (Realm) -> Void, completion: VoidCompletion? = nil) {
        Realm.current?.execute(execution, completion: completion)
    }
    
    static func executeOnMainThread(realm: Realm? = nil, _ execution: @escaping (Realm) -> Void) {
        if let realm = realm {
            if realm.isInWriteTransaction {
                execution(realm)
            } else {
                try? realm.write {
                    execution(realm)
                }
            }
            
            return
        }
        
        guard let curRealm = Realm.current else { return }
        
        if curRealm.isInWriteTransaction {
            execution(curRealm)
        } else {
            try? curRealm.write {
                execution(curRealm)
            }
        }
    }
    
    #if TEST
    static func clearDatabase() {
        Realm.execute({ realm in
            realm.deleteAll()
        })
    }
    #endif
    
    static func delete(_ object: Object) {
        guard !object.isInvalidated else { return }
        
        self.execute({ realm in
            realm.delete(object)
        })
    }
    
    static func update(_ object: Object) {
        self.execute({ realm in
            realm.add(object, update: .modified)
        })
    }
    
    static func update<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        self.execute({ realm in
            realm.add(objects, update: .modified)
        })
    }
}
