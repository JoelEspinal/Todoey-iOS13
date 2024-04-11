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
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
      
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        saveItems()
        
        
//        tableView.deselectRow(at: indexPath, animated: true)
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
                
                do {
                    try self.realm.write {
                        self.selectedCategory?.items.append(newItem)
//                        self.realm.add(newItem)
                    }
                } catch {
                    print("Error saving Item: \(error)")
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
    
    func saveItems(){
        if let category = selectedCategory {
            do {
    //            try self.context.save()
                try self.realm.write {
                    realm.add(category.items)
                }
            } catch {
                print("Error saving context. \(error)")
            }
            
            self.tableView.reloadData()
        }
        
        
    }
    
    func loadItems(/*with request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: Item.self)), predicate: NSPredicate? = nil*/) {
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name)
//        
//        if let aditionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, aditionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
            // TODO: ensure to filter with request params
            guard let items = realm.objects(Item.self).first else {return}
            selectedCategory?.items.append(items)
        
        
//            items.append(result)
        
//            items = result.items
            tableView.reloadData()
    }
}

// MARK: - Search bar methods
    
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        if !text.isEmpty {
//            let predicate/ = NSPredicate(format: "title Contains [cd] %@", text)
            
                
//                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Item.self))
//                let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//                fetchRequest.sortDescriptors = [sortDescriptor]
//                var request = try context.fetch<Item>(fetchRequest)
    
            guard let item = realm.objects(Item.self).first else {return}
            selectedCategory?.items.append(item)
            tableView.reloadData()
                
            loadItems()
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
