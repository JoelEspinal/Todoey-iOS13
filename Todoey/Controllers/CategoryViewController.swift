//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joel Espinal (JoelEspinal) on 27/3/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import Realm


class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories = List<Category>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadCategories()
    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView,  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)
        categoryCell.textLabel?.text = category.name
        return categoryCell
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category, update: .all)
            }
        } catch {
            print("Error saving context. \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        let result = realm.objects(Category.self)
        let categoryArray = result.toArray(ofType: Category.self)
        categories = RealmHelper.toList(categoryArray)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let categoryName = textField.text!
            if !categoryName.isEmpty {
                let category = Category()
                category.id = category.incrementID()
                category.name = categoryName
                self.categories.append(category)
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
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
}
