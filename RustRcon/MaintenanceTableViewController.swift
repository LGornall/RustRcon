//
//  MaintenanceTableViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 16/10/2017.
//  Copyright © 2017 ShantyShackApps. All rights reserved.
//

import UIKit

class MaintenanceTableViewController: UITableViewController, maintenanceView {
    
    
    @IBOutlet weak var decaySlider: UISlider!
    @IBOutlet weak var decayLabel: UILabel!
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func timeSliderDidChange(_ sender: Any) {
        setTimeLabelText(value: timeSlider.value)
    }
    @IBAction func decaySliderDidChange(_ sender: Any) {
        let decayPercentage = Int(decaySlider.value * 100)
        decayLabel.text = "\(decayPercentage)%"
        
    }
    
    @IBAction func setTimeBtnPress(_ sender: Any) {
        self.sendCommand(command: "env.time \(timeSlider.value)")
        let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
        alertViewController.notificationHeight = (self.navigationController?.navigationBar.intrinsicContentSize.height)!
            + UIApplication.shared.statusBarFrame.height
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func setDecayBtnPress(_ sender: Any) {
        self.sendCommand(command: "decay.scale \(decaySlider.value)")
        let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
        alertViewController.notificationHeight = (self.navigationController?.navigationBar.intrinsicContentSize.height)!
            + UIApplication.shared.statusBarFrame.height
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func setTimeLabelText(value :Float){
        let doubleStr = String(format: "%.2f", value)
        timeLabel.text = doubleStr
    }
    
    func timeFetched(value: Float) {
        timeSlider.setValue(value, animated: true)
        setTimeLabelText(value: value)
    }
    
    func decayFetched(value: Double) {
        decaySlider.setValue(Float(value), animated: false)
        let decayPercentage = Int(decaySlider.value * 100)
        decayLabel.text = "\(decayPercentage)%"
    }

    func sendCommand(command :String){
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.rconnection?.send(message: command, identifier: 6)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.maintenanceViewDelegate = self
        myNavBar.rconnection?.requestTime()
        myNavBar.rconnection?.requestDecay()
    }
    
    
    
    //== Row ==\\
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if(indexPath.row == 3){
            // fill animal pop
            sendCommand(command: "spawn.fill_populations")
            let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
            
            self.present(alertViewController, animated: true, completion: nil)
            
        }else if(indexPath.row == 4){
            //fill entity pop
            sendCommand(command: "spawn.fill_groups")
            let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
            
            self.present(alertViewController, animated: true, completion: nil)
            
        } else if(indexPath.row == 5){
            //entity clean up
            
            sendCommand(command: "global.cleanup")
            let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
            
            self.present(alertViewController, animated: true, completion: nil)
        }else if(indexPath.row == 7){
            //save
            sendCommand(command: "save")
            let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
            
            self.present(alertViewController, animated: true, completion: nil)
        }else if (indexPath.row == 8){
            //restart
            let restartConfirmation = UIAlertController(title: "Restart the Server?", message: "Please confirm that you want to restart the server, this may annoy people... and it might be a good idea to save.", preferredStyle: UIAlertControllerStyle.alert)
            restartConfirmation.addAction(UIAlertAction(title: "Restart Now!", style: UIAlertActionStyle.default, handler: {ACTION in
                
                self.sendCommand(command: "global.restart")
            }))
            restartConfirmation.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:{ ACTION in
                
            }))
            self.present(restartConfirmation, animated: true, completion: nil)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
