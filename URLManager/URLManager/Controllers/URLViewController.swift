//
//  ViewController.swift
//  URLManager
//
//  Created by George Hope on 26/02/2025.
//

import UIKit
import CoreData

class URLViewController: UITableViewController {

    var urlArray = [Item]()
    
    var chosenFolder: Folder? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        print("View did load")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView DataSource Methods
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlArray.count
    }
    
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath)
        
        let url = urlArray[indexPath.row]
        
        // Configure the cell’s contents.
//        cell.textLabel!.text = url.title
        
        var content = cell.defaultContentConfiguration()
        content.text = url.title
        content.secondaryText = url.link
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    //MARK: - TableView Swipe Method
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, boolValue in

            let folder = self.urlArray[indexPath.row]
            self.context.delete(folder)
            self.saveItems()
            self.loadItems()
            
        }
        
        
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        return swipeAction
    }
    
    //MARK: - Data Maniuplation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving data to database, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let folderPredicate = NSPredicate(format: "parentFolder.name MATCHES %@", chosenFolder!.name!)
        
        request.predicate = folderPredicate
        
        do {
            urlArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(urlArray[indexPath.row].title!)
    }
    
    //MARK: - Add new folders
        
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            // Open a UI window
            let alert = UIAlertController(title: "Add New URLManager Folder", message: "", preferredStyle: .alert)
            
            // Add a textfield
            alert.addTextField { UITextField in
                UITextField.placeholder = "Add title here..."
            }
            
            alert.addTextField { UITextField in
                UITextField.placeholder = "Add url here..."
            }
            
            let action = UIAlertAction(title: "Add New URL", style: .default, handler: { action in
                let newItem = Item(context: self.context)
                
                // Save text in textfield to Folder object
                newItem.title = alert.textFields?.first?.text
                newItem.link = alert.textFields?[1].text
                newItem.parentFolder = self.chosenFolder
                
                self.urlArray.append(newItem)
                self.saveItems()
                
            })
            
            alert.addAction(action)
            
            present(alert, animated: true, completion:  nil)
            
            
        }
    }


