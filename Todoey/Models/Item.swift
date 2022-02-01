//
//  Item.swift
//  Todoey
//
//  Created by Faraz Khan on 31/01/22.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var title: String = ""
	@objc dynamic var isDone: Bool = false
	@objc dynamic var date: Date = Date()
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
