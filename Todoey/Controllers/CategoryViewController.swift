//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joel Espinal (JoelEspinal) on 27/3/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import Realm


class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories = List<Category>()
    
//    var itemArray: [Category] = [Category]()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
//        do {
//            let result = RealmHelper.getObjects<Category>()
////            result.
//             
//
//            let a  =   RealmHelper.toList(result)
//
//        } catch {
//            print("error error")
//        }
//        
//            
//        let a = RealmHelper.toList(result)
//        
//        
//        
//        categories = a
//        
        
       
//        items = result.items
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
//        let categoryItem = categories[indexPath.row]
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< self.count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}
