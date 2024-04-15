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
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var parentCategory = 0
    
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Item.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
