//
//  ViewController.swift
//  Todoey
//
//  Created by Castiel Li on 2018-03-03.
//  Copyright © 2018 Castiel Li. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let todoListArrayKey = "TodoListArray"
    var itemArray = [Item]()
    //userDomainMask -> App directory where all data in the app will be stored
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK - Tableview Datasource Methods
    //display the number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ===>
        // value = condition ? valueIfTrue : valueIfFalse
        //set the check mark if item is done
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //swap true and false
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        //so the row does not stay grey as been selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Action when user clicks the Add Item button on UIAlert
            if(!(textField.text!.isEmpty)){
                //create a new item and set its title to user input
                let newItem = Item()
                newItem.title = textField.text!
                //add the new item into the array
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        //create a text field in alert
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        //add the add button action to alert
        alert.addAction(action)
        //display the alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

