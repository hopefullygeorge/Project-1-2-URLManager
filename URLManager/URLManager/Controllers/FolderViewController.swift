//
//  FolderViewController.swift
//  URLManager
//
//  Created by George Hope on 27/02/2025.
//

import UIKit
import CoreData


class FolderViewController: UITableViewController {
    
    var folderArray = [Folder]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFolders()
    }
    
    //MARK: - TableView DataSource Methods
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderArray.count
    }
    
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
        
        let folder = folderArray[indexPath.row]
        
        // Configure the cell’s contents.
        cell.textLabel!.text = folder.name
        
        return cell
    }
    
    //MARK: - Data Maniuplation Methods
    
    func saveFolders() {
        do {
            try context.save()
        } catch {
            print("Error saving data to database, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadFolders(with request : NSFetchRequest<Folder> = Folder.fetchRequest()) {
        
        do {
            folderArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
    
    
        //MARK: - TableView Delegate Methods
        
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            // Open a UI window
            let alert = UIAlertController(title: "Test Title", message: "Test Message", preferredStyle: .alert)
            
            // Add a textfield
            alert.addTextField { UITextField in
                UITextField.placeholder = "Test Placeholder"
            }
            
            let action = UIAlertAction(title: "Test Action Title", style: .default, handler: { action in
                let newFolder = Folder(context: self.context)
                
                // Save text in textfield to Folder object
                newFolder.name = alert.textFields?.first?.text
                self.folderArray.append(newFolder)
                self.saveFolders()
                
            })
            
            alert.addAction(action)
            
            present(alert, animated: true, completion:  nil)
            
            
        }
    }
