//
//  Item.swift
//  ListHue
//
//  Created by Bunlong Heng on 8/2/18.
//  Copyright © 2018 LR Web Design. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
