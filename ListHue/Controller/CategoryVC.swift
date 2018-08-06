//
//  CategoryVC.swift
//  ListHue
//
//  Created by Bunlong Heng on 8/2/18.
//  Copyright © 2018 LR Web Design. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class CategoryVC: SwipeTableVC {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.rowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Todo"
        
        guard let navBar = navigationController?.navigationBar else { fatalError() }
//        guard let navBarColor = UIColor(hexString: "fff") else { fatalError() }
//        
//        print(navBarColor)
//        
//        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(FlatBlack(), returnFlat: true)
        navBar.largeTitleTextAttributes =   [NSAttributedStringKey.foregroundColor: FlatWhite()]
        
        view.backgroundColor = UIColor.flatBlack

        

    }
    
    
    // ---------------------------------------------------------------------------------------------------------
    //MARK - Table View Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        tableView.separatorStyle = .none
        
        return cell
        
    }
    
    
    // ---------------------------------------------------------------------------------------------------------
    //MARK - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    

    // ---------------------------------------------------------------------------------------------------------
    //MARK - Data Manipulation Methods
    

    
    //Create
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    //Read
    func loadCategories() {
        
        categories  = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("click")
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
    
        present(alert, animated: true, completion: nil)
        
    }
    
}

