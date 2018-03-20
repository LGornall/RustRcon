//
//  BannedPlayerTableViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 22/10/2017.
//  Copyright © 2017 ShantyShackApps. All rights reserved.
//

import UIKit

class BannedPlayerTableViewController: UITableViewController, bannedPlayerView {
    
    var bannedPlayerList: [bannedPlayer] = []
    
    func bannedPlayersFetched(bannedPlayers: [bannedPlayer]) {
        bannedPlayerList = bannedPlayers
        self.tableView.reloadData()
        
        self.title = "Naughty List"
    }
    
    func sendCommand(command :String){
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.rconnection?.send(message: command, identifier: 6)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "loading"
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.bannedPlayerViewDelegate = self
        myNavBar.rconnection?.requestBannedPlayers()
        //myNavBar = self as!
        
        //myNavBar.rconnection?.requestBannedPlayers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! bannedPlayerCell
        
        cell.playerNameLabel.text = bannedPlayerList[indexPath.row].playerName
        cell.banReason.text = "Reason: \(bannedPlayerList[indexPath.row].Reason)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bannedPlayerList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let unbanConfirmation = UIAlertController(title: "Unban \(bannedPlayerList[indexPath.row].playerName)", message: "Are you sure you want to unban \(bannedPlayerList[indexPath.row].playerName).", preferredStyle: UIAlertControllerStyle.alert)
        unbanConfirmation.addAction(UIAlertAction(title: "Forgive", style: UIAlertActionStyle.default, handler: {ACTION in
            
            self.sendCommand(command: "global.unban \(self.bannedPlayerList[indexPath.row].SteamID)")
            let myNavBar = self.navigationController as! ServerNavViewController
            myNavBar.rconnection?.requestBannedPlayers()
        }))
        unbanConfirmation.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:{ ACTION in
        }))
        self.present(unbanConfirmation, animated: true, completion: nil)

        
    }
    
}
