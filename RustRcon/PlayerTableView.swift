//
//  PlayerTableView.swift
//  RustRcon
//
//  Created by Louis Gornall on 01/10/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit

class PlayerTableView: UITableViewController {
    //write a func
    
    
    @IBOutlet weak var label_playerName: UILabel!
    @IBOutlet weak var label_SteamID: UILabel!
    @IBOutlet weak var label_Ping: UILabel!
    @IBOutlet weak var label_ConnectedFor: UILabel!
    
    @IBOutlet weak var label_IPAddress: UILabel!
    var Player: player!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        label_playerName.text = Player.DisplayName
        label_SteamID.text = Player.SteamID
        label_Ping.text = "\(Player.Ping)ms"
        label_IPAddress.text  = Player.Address
        label_ConnectedFor.text = secondsToHoursMinutesSecondsString(seconds: Player.ConnectedSeconds)
        
    }
    
    
    
    func sendCommand(command :String){
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.rconnection?.send(message: command, identifier: 6)
    }
    
    
    
    func secondsToHoursMinutesSecondsString (seconds : Int) -> String {
        let hours = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60
        
        var hoursZero = ""
        if hours < 10 { hoursZero = "0"}
        var minutesZero = ""
        if minutes < 10 { minutesZero = "0"}
        var secondsZero = ""
        if seconds < 10 { secondsZero = "0"}
        
        
        return "\(hoursZero)\(hours):\(minutesZero)\(minutes):\(secondsZero)\(seconds)"
    }

    func showConfirmation(){
        let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
        alertViewController.notificationHeight = (self.navigationController?.navigationBar.intrinsicContentSize.height)!
            + UIApplication.shared.statusBarFrame.height
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if(indexPath.row == 6){
            sendCommand(command: "mutechat \(Player.SteamID)")
            showConfirmation()
        } else if(indexPath.row == 7){
            sendCommand(command: "mutevoice \(Player.SteamID)")
            showConfirmation()
        } else if(indexPath.row == 8){
            sendCommand(command: "unmutechat \(Player.SteamID)")
            showConfirmation()
        } else if(indexPath.row == 9){
            sendCommand(command: "unmutevoice \(Player.SteamID)")
            showConfirmation()
        } else if(indexPath.row == 11) {
            sendCommand(command: "Kick \(Player.SteamID)")
            showConfirmation()
        } else if(indexPath.row == 12) {
            sendCommand(command: "Ban \(Player.SteamID)")
            showConfirmation()
        }
    }
}
