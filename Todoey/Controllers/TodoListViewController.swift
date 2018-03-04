//
//  ViewController.swift
//  Todoey
//
//  Created by Castiel Li on 2018-03-03.
//  Copyright © 2018 Castiel Li. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {

    let todoListArrayKey = "TodoListArray"
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //userDomainMask -> App directory where all data in the app will be stored
    
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        //swap true and false so the check mark display correctly 
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //have to be in order, othewise array out index
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
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
                let newItem = Item(context: self.context)
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
    
    //MARK - Model Manupulation Methods CRUD
    //Save data
    func saveItems() {
        do{
           try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    //Read data
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error feching data from context \(error)")
        }
    }
    
}

