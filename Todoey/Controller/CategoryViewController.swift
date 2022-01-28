//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Faraz Khan on 28/01/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

	var categoryArr = [Category]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
		loadCategory()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
		cell.textLabel?.text = categoryArr[indexPath.row].name
        return cell
	}

	//delegate method didSelect
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! ItemViewController
		if let indexPath  = tableView.indexPathForSelectedRow {

			destinationVC.selectedCategory = categoryArr[indexPath.row]
			
		}
		
	}
	
	@IBAction func categoryBarButtonPressed(_ sender: UIBarButtonItem) {
		var alertText = UITextField()
		let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "ADD", style: .default) { (action) in
			let newCategory = Category(context: self.context)
			newCategory.name = alertText.text
			self.categoryArr.append(newCategory)
			self.saveCategory()
			self.tableView.reloadData()
		}
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Enter the Category"
			alertText = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	func saveCategory() {
		do{
			try context.save()
		} catch {
			print("Category saving error: \(error)")
		}
	}
	
	func loadCategory() {
		let request: NSFetchRequest<Category> = Category.fetchRequest()
		do {
			categoryArr = try context.fetch(request)
			
			tableView.reloadData()
		} catch {
			print("Category fetch error: \(error)")
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
