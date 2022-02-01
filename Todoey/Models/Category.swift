//
//  Category.swift
//  Todoey
//
//  Created by Faraz Khan on 31/01/22.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name: String = ""
	let items = List<Item>()
}
