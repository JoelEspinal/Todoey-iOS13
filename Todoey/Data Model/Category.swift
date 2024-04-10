//
//  Category.swift
//  Todoey
//
//  Created by Joel Espinal (ClaroDom) on 5/4/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted(primaryKey: true) var id = 0
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
