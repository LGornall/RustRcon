//
//  itemDetailTableViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 08/10/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit
import CoreData

class itemDetailTableViewController: UITableViewController {

    @IBOutlet weak var itemHeader: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!

    func showConfirmation(){
        let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
        alertViewController.notificationHeight = (self.navigationController?.navigationBar.intrinsicContentSize.height)!
            + UIApplication.shared.statusBarFrame.height
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    
    var selectedItem: Item?
    
    func giveAll(quantity: Int) {
        
        let itemShortName = selectedItem!.value(forKey: "shortName")
        let cmdString = "giveall \(itemShortName ?? String.self) \(quantity)"
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.rconnection?.send(message: cmdString, identifier: 6)
        showConfirmation()
        
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "giveToPlayerSegue"){
            let destinationTabController = segue.destination as! ItemPlayersView
            destinationTabController.selectedItem = self.selectedItem
            destinationTabController.quantity = Int(amountTextField.text!)!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        itemHeader.text = selectedItem?.name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 1){
            return 75
            
        } else {
        
            return 45.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 3){
            amountTextField.text = "1"
        }else if(indexPath.row == 4){
            amountTextField.text = "10"
        }else if(indexPath.row == 5){
            amountTextField.text = "100"
        }else if(indexPath.row == 6){
            amountTextField.text = "1000"
        }else if(indexPath.row == 7){
            giveAll(quantity: Int(amountTextField.text!)!)
        }
    }

}
