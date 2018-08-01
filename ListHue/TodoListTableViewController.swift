//
//  TodoListTableViewController.swift
//  ListHue
//
//  Created by Bunlong Heng on 8/1/18.
//  Copyright © 2018 LR Web Design. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    let items = ["Find Mike", "Buy Eggos", "Kill Demogorgon"]
    
    //    viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }

}
