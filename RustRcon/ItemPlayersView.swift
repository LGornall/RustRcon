//
//  ItemPlayerView.swift
//  RustRcon
//
//  Created by Louis Gornall on 12/10/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit

class ItemPlayersView: UITableViewController {

    var playerList: [player] = []
    var selectedPlayer: player?
    
    var selectedItem: Item?
    var quantity: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myNavBar = self.navigationController as! ServerNavViewController
        
        playerList = myNavBar.playerList
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func giveItem(selectedPlayer: player){
        
        let itemShortName = selectedItem!.value(forKey: "shortName")
        let cmdString = "giveall \(itemShortName ?? String.self) \(quantity)"
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.rconnection?.send(message: cmdString, identifier: 6)
        _ = navigationController?.popViewController(animated: true)
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

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        giveItem(selectedPlayer: playerList[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (playerList.count)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayerViewCell
        let connectedString = secondsToHoursMinutesSecondsString(seconds: playerList[indexPath.row].ConnectedSeconds)

        cell.playnameLabel.text = playerList[indexPath.row].DisplayName
        cell.playerConnected.text = "\(connectedString)"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
