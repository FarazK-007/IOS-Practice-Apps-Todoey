//
//  ViewController.swift
//  Todoey
//
//  Created by Faraz Khan on 24/01/22.
//

import UIKit

class ViewController: UITableViewController {
	
	var arr = [Items]()
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let newItem1 = Items()
		newItem1.itemName = "First"
		arr.append(newItem1)
		
		let newItem2 = Items()
		newItem2.itemName = "Second"
		arr.append(newItem2)
		
		let newItem3 = Items()
		newItem3.itemName = "Third"
		arr.append(newItem3)
	}
	
	//TableView Data Sources
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arr.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		cell.textLabel?.text = arr[indexPath.row].itemName
		return cell
	}
	
	//TableView Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		arr[indexPath.row].isDone = !arr[indexPath.row].isDone
		tableView.cellForRow(at: indexPath)?.accessoryType = arr[indexPath.row].isDone ? .checkmark : .none
		saveItems()
	}

	@IBAction func barAddButtonPressed(_ sender: UIBarButtonItem) {
		
		var alertText = UITextField()
		
		let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "ADD", style: .default) { (action) in
			
			let newItem = Items()
			newItem.itemName = alertText.text!
			
			self.arr.append(newItem)
			self.saveItems()
			
			self.tableView.reloadData()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Add Name of an Item"
			alertText = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	func saveItems() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(arr)
			try data.write(to: dataFilePath!)
		} catch {
			print("Error by Encoder: \(error)")
		}
	}
}

