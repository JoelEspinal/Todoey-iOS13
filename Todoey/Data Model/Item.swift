//
//  Item.swift
//  Todoey
//
//  Created by Joel Espinal (ClaroDom) on 5/4/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted(primaryKey: true) var id = 0
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Item.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
