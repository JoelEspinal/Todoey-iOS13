//
//  RealmHelper.swift
//  Todoey
//
//  Created by Joel Espinal (ClaroDom) on 10/4/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//


import UIKit
import RealmSwift

import Foundation
class RealmHelper {
    static func saveObject<T:Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    static func getObjects<T:Object>()->[T] {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self)
        return Array(realmResults)
        
    }
    static func getObjects<T:Object>(filter:String)->[T] {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self).filter(filter)
        return Array(realmResults)
        
    }
    
    static func toList<T:Object>(_ array: [T])->List<T> {
        let list = List<T>()
        if !array.isEmpty {
            list.append(objectsIn: array)
        }
        
        return list
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< self.count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}
