//
//  ItemVC
//  ListHue
//
//  Created by Bunlong Heng on 8/1/18.
//  Copyright © 2018 LR Web Design. All rights reserved.
//  testing 
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemVC: SwipeTableVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
 
    // ---------------------------------------------------------------------------------------------------------
    //MARK - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.color else { fatalError() }
        updateNavBar(withHexCode: colorHex)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "000")
    }
    
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError() }
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes =   [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
        
    }
    
    
    // ---------------------------------------------------------------------------------------------------------
    //MARK - Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
    
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    
    // ---------------------------------------------------------------------------------------------------------
    //MARK - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    // ---------------------------------------------------------------------------------------------------------
    //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // ---------------------------------------------------------------------------------------------------------
    //MARK - Model Manipulation Methods
    
    
    func save(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    }

}

//MARK: - Search bar methods
extension ItemVC : UISearchBarDelegate {
    
    func  searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

