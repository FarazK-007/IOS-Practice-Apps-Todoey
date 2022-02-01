//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Faraz Khan on 28/01/22.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {

	var categoryArr: Results<Category>?
	let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadCategory()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoryArr?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		cell.textLabel?.text = categoryArr?[indexPath.row].name ?? "No Categories"
        return cell
	}

	//MARK: - Delegate method didSelect and Prepare
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! ItemViewController
		if let indexPath  = tableView.indexPathForSelectedRow {

			destinationVC.selectedCategory = categoryArr?[indexPath.row]

		}

	}

	//MARK: - IBAction
	@IBAction func categoryBarButtonPressed(_ sender: UIBarButtonItem) {
		var alertText = UITextField()
		
		let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "ADD", style: .default) { (action) in
			let newCategory = Category()
			newCategory.name = alertText.text!
			self.saveCategory(category: newCategory)
		}
		
		alert.addAction(action)
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Enter the Category"
			alertText = alertTextField
		}
		
		present(alert, animated: true, completion: nil)
	}

	//MARK: - Data Manipulation
	func saveCategory(category: Category) {
		do{
			try realm.write {
				realm.add(category)
			}
		} catch {
			print("Category saving error: \(error)")
		}
		tableView.reloadData()
	}

	func loadCategory() {
		categoryArr = realm.objects(Category.self)
		tableView.reloadData()
	}
	
	override func updateModel(at indexPath: IndexPath) {
		if let categoryForDeletion = categoryArr?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(categoryForDeletion)
				}
			} catch {
				print("Error deleting category, \(error)")
			}
		}
	}
}
