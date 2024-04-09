//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joel Espinal (JoelEspinal) on 27/3/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var items = List<Category>()
    
    var itemArray: [Category] = [Category]()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView,  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)
        
        let category = itemArray[indexPath.row]
        categoryCell.textLabel?.text = category.name
        
        return categoryCell
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
//        let encoder = PropertyListEncoder()
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        
        } catch {
            print("Error saving context. \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: Category.self))) {
    
        guard let result = realm.objects(Category.self).first else {return}
        
//            items = result.items
            tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let categoryName = textField.text!
            if !categoryName.isEmpty {
                let category = Category()
                category.name = categoryName
                self.itemArray.append(category)
                
                self.save(category: category)
            }
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - TableView Delegate Methods
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryItem = itemArray[indexPath.row]
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = itemArray[indexPath.row]
        }
    }
}
