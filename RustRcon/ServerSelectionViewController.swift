//
//  ServerSelectionViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 23/09/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit
import CoreData

class ServerSelectionViewController: UITableViewController{
    
    var serverList: [NSManagedObject] = []
    var editServerIndex: Int?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedServer: Server?
    
    func loadServerList(){
        serverList = []
        do { let results = try context.fetch(Server.fetchRequest())
            serverList = results as! [NSManagedObject]
        } catch {
            print(error.localizedDescription)
        }
        print(serverList.count, " that was it")
        print("loading")
        tableView.reloadData()
    }
    
    /*-----uiViewcontroller funcs-----*/
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Servers"
        selectedServer = nil
        loadServerList()
        //tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    

    /*-----Segue funcs----*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var senderAsString: String = ""
        if sender is String{
            senderAsString = sender as! String
        }
        
        if(segue.identifier == "serverSelectedSegue"){
            
            let destinationTabController = segue.destination as! ServerNavViewController
            destinationTabController.targetServer = selectedServer
            
        } else if segue.identifier == "addServerSegue" && senderAsString == "edit"{
            let destinationViewController = segue.destination as! AddServerViewController
            destinationViewController.indexOfServerToEdit = editServerIndex
            destinationViewController.serverToEdit = selectedServer
            
        }
    }
    
    /*-----tableviewcontroller funcs-----*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedServer = (serverList[indexPath.row] as! Server)
        
        performSegue(withIdentifier: "serverSelectedSegue", sender: Any?.self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServerTableCell
        
        let item = serverList[indexPath.row]
        cell.title.text = item.value(forKey: "name") as? String
        cell.address.text = item.value(forKey: "ipaddress") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action, indexPath) in
            self.editServerIndex = indexPath.row
            self.selectedServer = self.serverList[indexPath.row] as? Server
            self.performSegue(withIdentifier: "addServerSegue", sender: "edit")
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.context.delete(self.serverList[indexPath.row])
                do {
                    try self.context.save()
                    self.loadServerList()
                    tableView.reloadData()
                } catch {
                    print ("error saving deleting: ", error.localizedDescription )
                }
        })
        
        return [deleteAction, editAction]
    }
        
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
}





