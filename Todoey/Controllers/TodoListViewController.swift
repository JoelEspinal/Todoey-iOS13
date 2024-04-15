//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK - Tableview DatasourceMethodd
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategory?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = selectedCategory?.items[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = (item.done) ? .checkmark  : .none
        }
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = selectedCategory?.items[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
            tableView.reloadData()
        }
    }
    
    // MARK - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newTitle = textField.text!
            if !newTitle.isEmpty {
                let newItem = Item()
                newItem.id = newItem.incrementID()
                newItem.title = newTitle
                newItem.done = false
                
                do{
                    try self.realm.objects(Item.self).realm?.write({
                        self.selectedCategory?.items.append(newItem)
                    })
                    
                    self.tableView.reloadData()
                } catch {
                    print("Error saving items in selected Category \(error)")
                }
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    func loadItems() {
//        if let category = selectedCategory {
//            //            let predicate = NSPredicate(format: "id = %@", category.id)
//            let item = realm.objects(Item.self)
//            
//            let result = item.where {
//                $0.parentCategory == category.id
//                
//                // "Unable to parse the format string \"(ANY .id == %@)\""
//               // return    // .parentCategory.id == category.id
//            }
//            
//            var itemsArray = result.toArray(ofType: Item.self)
//            tableView.reloadData()
//        }

    }
}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        if !text.isEmpty {
            
            
//            selectedCategory.items = selectedCategory.items.filter("title CONTAINS[dc] %@", searchBar.text)
//
            
            
            //            let predicate/ = NSPredicate(format: "title Contains [cd] %@", text)
            
            
            //                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Item.self))
            //                let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            //                fetchRequest.sortDescriptors = [sortDescriptor]
            //                var request = try context.fetch<Item>(fetchRequest)
            
//            guard let item = realm.objects(Item.self).first else {return}
//            selectedCategory?.items.append(item)
//            tableView.reloadData()
//            
//            loadItems()
            //                loadItems(with: fetchRequest, predicate: predicate)
        } else {
            loadItems()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}
