//
//  ItemTableViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 04/10/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController, UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadItems()
        tableView.reloadData()
    }
    
    @IBOutlet weak var itemSearchBar: UISearchBar!
    var filter: String?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemList: [Item] = []

    var selectedItem: Item?
    
    func loadItems(){
        
        let request =  NSFetchRequest<NSFetchRequestResult>(entityName:"Item")
        var predicate: NSPredicate
        if itemSearchBar.text == "" {
            predicate = NSPredicate(format:"category == %@", filter!)
        }else{
            predicate = NSPredicate(format:"category == %@ && name CONTAINS[c] %@", filter!, itemSearchBar.text!)
        }
        request.predicate  = predicate
        
        do { let results = try context.fetch(request)
            itemList = results as! [Item]
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSelectedSegue"{
            let destinationTabController = segue.destination as! itemDetailTableViewController
            destinationTabController.selectedItem = selectedItem
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = filter
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
        itemSearchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    
        return itemList.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = itemList[indexPath.row]
        performSegue(withIdentifier: "itemSelectedSegue", sender: Any?.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! ItemTableCell
        
        let item = itemList[indexPath.row]
        cell.itemName.text = item.value(forKey: "name") as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
 
}
