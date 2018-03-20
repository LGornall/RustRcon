//
//  AddServerViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 23/09/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit
import CoreData

class AddServerViewController: UIViewController, UIBarPositioningDelegate {
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    
    var indexOfServerToEdit: Int?
    var serverToEdit : Server?
    
    //IBoutlets
    @IBOutlet weak var serverNameTxtField: UITextField!
    
    @IBOutlet weak var ipaddTxtField: UITextField!
    
    @IBOutlet weak var rconPortTxtField: UITextField!
    
    @IBOutlet weak var serverPwdTxtField: UITextField!
    @IBOutlet weak var requiredLabel: UILabel!
    //IBActions
    
    @IBAction func IPAdrressTxtField(_ sender: Any) {
        if(isValidIPAddress(ipAddress: ipaddTxtField.text!)){
            ipaddTxtField.backgroundColor = UIColor.green
        } else {
            ipaddTxtField.backgroundColor = UIColor.red
        }
    }
    @IBAction func saveButton(_ sender: Any) {
        if(isEmpty(txtField: serverNameTxtField)) || (isEmpty(txtField: ipaddTxtField)) || (isEmpty(txtField: rconPortTxtField)) || (isEmpty(txtField: serverPwdTxtField)){
            
            requiredLabel.isHidden = false
            
        } else if indexOfServerToEdit != nil {
            
            let rconPortInt = Int64(rconPortTxtField.text!)
            serverToEdit?.setValue(serverNameTxtField.text, forKey: "name")
            serverToEdit?.setValue(ipaddTxtField.text, forKey: "ipaddress")
            serverToEdit?.setValue(serverPwdTxtField.text, forKey: "password")
            serverToEdit?.setValue(rconPortInt, forKey: "port")
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            do {
                try context.save()
            } catch {
                print ("error saving the update: ", error.localizedDescription )
            }
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
                 
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let serv = Server(context: context)
            let rconPortInt = Int64(rconPortTxtField.text!)

            serv.name = serverNameTxtField.text
            serv.ipaddress = ipaddTxtField.text
            serv.port = rconPortInt!
            serv.password = serverPwdTxtField.text
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            let tmpController :UIViewController! = self.presentingViewController;
            
            self.dismiss(animated: true, completion: {()->Void in
                tmpController.dismiss(animated: true, completion: nil);
            });
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //my functions
    override func viewDidLoad() {
        //self.view.backgroundColor = UIColor.clear
        if (indexOfServerToEdit != nil){
            loadServerDetails(index: indexOfServerToEdit!)
        }
        
    }
    
    func loadServerDetails(index: Int){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var serverList:[NSManagedObject] = []
        do { let results = try context.fetch(Server.fetchRequest())
            serverList = results as! [NSManagedObject]
        } catch {
            print(error.localizedDescription)
        }
        

        serverNameTxtField.text = serverList[index].value(forKey: "name") as? String
        ipaddTxtField.text = serverList[index].value(forKey: "ipaddress") as? String
        rconPortTxtField.text = "\(serverList[index].value(forKey: "port") as! Int64)"
        serverPwdTxtField.text = serverList[index].value(forKey: "password") as? String
        
        
    }
    
    func isValidIPAddress(ipAddress: String) -> Bool {
        //let parts = ipAddress.componentsSeparatedByString(".")
        let parts = ipAddress.components(separatedBy: ".")
        let nums = parts.flatMap { Int($0) }
        return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
    }
    
    func isEmpty(txtField :UITextField) -> Bool{
        if(txtField.text == ""){
            txtField.backgroundColor = UIColor.red
            return true
        } else {
            txtField.backgroundColor = UIColor.green
            
            return false
        }
        
    }
}


