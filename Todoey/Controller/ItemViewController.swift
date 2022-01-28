//
//  ViewController.swift
//  Todoey
//
//  Created by Faraz Khan on 24/01/22.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {
	
	var arr = [Item]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	var selectedCategory: Category? {
		didSet {
			loadData()
		}
	}
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		print(dataFilePath)
		
	}
	
	//TableView Data Sources
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arr.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		cell.textLabel?.text = arr[indexPath.row].title
		cell.accessoryType = arr[indexPath.row].isDone ? .checkmark : .none
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
			
			let newItem = Item(context: self.context)
			newItem.isDone = false
			newItem.title = alertText.text!
			newItem.parentCategory = self.selectedCategory
			
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
		do {
			try context.save()
		} catch {
			print("Error by Encoder: \(error)")
		}
	}
	
	func loadData(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
		
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		
		if let funcPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,funcPredicate])
		} else {
			request.predicate = categoryPredicate
		}
		
		do {
			arr = try context.fetch(request)
			
			tableView.reloadData()
		} catch {
			print("Error by Decoder: \(error)")
		}
	}
}

extension ItemViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		loadData(with: request, predicate: predicate)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadData()
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}
}

