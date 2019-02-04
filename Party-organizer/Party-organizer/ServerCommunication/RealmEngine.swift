//
//  RealmEngine.swift
//  Party-organizer
//
//  Created by Srdjan Spasojevic on 2/2/19.
//  Copyright © 2019 Srdjan Spasojevic. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEngine: NSObject
{
    static let shared = RealmEngine()
    
    var realm = try! Realm()
    
    func add<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
    func add<T: Object>(_ objects: [T]) {
        do {
            try realm.write {
                
                for object in objects
                {
                    realm.add(object)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }
    
    func resetRealm()
    {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            post(error)
        }
    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"),
                                               object: nil,
                                               queue: nil) { (notification) in
                                                completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
}
