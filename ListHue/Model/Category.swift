//
//  Category.swift
//  ListHue
//
//  Created by Bunlong Heng on 8/2/18.
//  Copyright © 2018 LR Web Design. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
