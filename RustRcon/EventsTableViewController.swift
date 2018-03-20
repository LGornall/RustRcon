//
//  EventsTableViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 18/10/2017.
//  Copyright © 2017 ShantyShackApps. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, eventsView {
    
    @IBOutlet weak var txtfield_HeliDuration: UITextField!
    @IBOutlet weak var sldr_HeliAccuracy: UISlider!
    @IBOutlet weak var sgmt_HeliDamage: UISegmentedControl!
    
    var damageValue: Float = 0
    
    @IBAction func heliDamageChanged(_ sender: Any) {
        print("heli changed",sgmt_HeliDamage.selectedSegmentIndex)
        if sgmt_HeliDamage.selectedSegmentIndex == 0 {
            damageValue = 0.5
        } else if sgmt_HeliDamage.selectedSegmentIndex == 1{
            damageValue = 1
        } else {
             damageValue = 2
        }
    }
    
    func sendCommand(command :String){
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.rconnection?.send(message: command, identifier: 6)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "loading..."
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.eventViewDelegate = self
        myNavBar.rconnection?.requestHeliLiftime()
        myNavBar.rconnection?.requestHeliGunAccuracy()
        myNavBar.rconnection?.requestHeliGunDamage()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func heliAccuracyFetched(value: Float) {
        sldr_HeliAccuracy.value = value
    }
    
    func heliLifeTimeFetched(value: Float) {
        txtfield_HeliDuration.text = "\(value)"
    }
    
    func heliBulletDmgFetched(value: Float) {
        if value > 1{
            sgmt_HeliDamage.selectedSegmentIndex = 2
            damageValue = 2
        } else if value < 1{
            sgmt_HeliDamage.selectedSegmentIndex = 0
            damageValue = 0.5
        } else {
            sgmt_HeliDamage.selectedSegmentIndex = 1
            damageValue = 1.0
        }
        
        self.title = "Events"
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4{
            //heli save
            let heliLifeText: String = txtfield_HeliDuration.text!
            sendCommand(command: "heli.lifetimeminutes \(heliLifeText)")
            sendCommand(command: "heli.bulletdamagescale \(damageValue)")
            sendCommand(command: "heli.bulletaccuracy \(sldr_HeliAccuracy.value)")
            
            let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
            
            self.present(alertViewController, animated: true, completion: nil)
            
        }else if indexPath.row == 5{
            //Heli Call
            sendCommand(command: "heli.call")
            let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
            
            self.present(alertViewController, animated: true, completion: nil)
        }else if indexPath.row == 7{
            //Supply Call
            sendCommand(command: "supply.call")
            let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
            
            self.present(alertViewController, animated: true, completion: nil)
        }
        
    }

}
