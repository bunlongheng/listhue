//
//  TodoListVC
//  ListHue
//
//  Created by Bunlong Heng on 8/1/18.
//  Copyright © 2018 LR Web Design. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    
    // ---------------------------------------------------------------------------------------------------------
    //MARK - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Find Mike"
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        newItem2.done = false
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Kill Demogorgon"
        newItem3.done = false
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ItemArray") as? [Item] {
            itemArray = items
        }
        
    }
    

    // ---------------------------------------------------------------------------------------------------------
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath Called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    
    // ---------------------------------------------------------------------------------------------------------
    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    // ---------------------------------------------------------------------------------------------------------
    //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        //action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
        
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ItemArray")
            self.tableView.reloadData()
            
        }
        

        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            print(alertTextField.text)
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    

}
