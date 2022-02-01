//
//  ViewController.swift
//  Todoey
//
//  Created by Faraz Khan on 24/01/22.
//

import UIKit
import RealmSwift

class ItemViewController: SwipeTableViewController {
	
	var arr: Results<Item>?
	let realm = try! Realm()

	var selectedCategory: Category? {
		didSet {
			loadData()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	//MARK: - TableView Data Sources
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arr?.count ?? 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		cell.textLabel?.text = arr?[indexPath.row].title
		cell.accessoryType = (arr?[indexPath.row].isDone)! ? .checkmark : .none
		return cell
	}

	//MARK: - TableView Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = arr?[indexPath.row] {
			do {
				try realm.write{
					item.isDone = !item.isDone
				}
			} catch {
				print(error)
			}
		}
		
		tableView.reloadData()
		tableView.deselectRow(at: indexPath, animated: true)

	}
	
	//MARK: - IBAction
	@IBAction func barAddButtonPressed(_ sender: UIBarButtonItem) {

		var alertText = UITextField()

		let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "ADD", style: .default) { (action) in

			if let currCategory = self.selectedCategory {
				try! self.realm.write{
					let newItem = Item()
					newItem.title = alertText.text!
					newItem.date = Date()
					currCategory.items.append(newItem)
				}
			}

			self.tableView.reloadData()
		}

		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Add Name of an Item"
			alertText = alertTextField
		}

		alert.addAction(action)

		present(alert, animated: true, completion: nil)
	}
	
	//MARK: - Load Data
	func loadData(){
		arr = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		tableView.reloadData()
	}
	
	override func updateModel(at indexPath: IndexPath) {
		if let itemArrForDeletion = arr?[indexPath.row] {
			do {
				try realm.write{
					realm.delete(itemArrForDeletion)
				}
			} catch {
				print(error)
			}
		}
	}
}

//MARK: - Extension: UISearchBarDelegate
extension ItemViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		arr = arr?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
		
		tableView.reloadData()
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

