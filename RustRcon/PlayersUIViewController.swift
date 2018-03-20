//
//  PlayersUIViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 25/09/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit
//list of players
class PlayersUIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, playersView {
    func maxPlayersreceived(maxPlayers: Int) {
        self.maxPlayers = maxPlayers
        self.title = "\(playerList.count)/\(maxPlayers)"
    }
    
    @IBOutlet weak var playersTableView: UITableView!
    var playerList: [player] = []
    var maxPlayers: Int = 0

    var selectedPlayer: player?
    
    func playersUpdated(players: [player]) {
        playerList = players
        let myNavBar = self.navigationController as! ServerNavViewController!
        myNavBar?.playerList = players
        self.title = "\(players.count)/\(maxPlayers)"
        playersTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myNavBar = self.navigationController as! ServerNavViewController!
        
        //tabBar?.playerViewDelegate = self
        myNavBar?.playerViewDelegate = self
        playersTableView.delegate = self
        myNavBar?.rconnection?.requestMaxPlayers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let myNavBar = self.navigationController as! ServerNavViewController!
        myNavBar?.playerViewDelegate = self
        playersTableView.delegate = self
        playersTableView.dataSource = self
        myNavBar?.rconnection?.requestMaxPlayers()
        myNavBar?.rconnection?.requestListofPlayers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*-----Segue funcs----*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "playerSelectedSegue"){
            let destinationTabController = segue.destination as! PlayerTableView
            destinationTabController.Player = selectedPlayer            
        }
    }
    
    
    //UITableView funcs
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPlayer = (playerList[indexPath.row] )
        
        performSegue(withIdentifier: "playerSelectedSegue", sender: Any?.self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (playerList.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayerViewCell
        
        //let item = serverList[indexPath.row]
        
        //let connectedString = "\(playerList[indexPath.row].ConnectedSeconds)"
        let connectedString = secondsToHoursMinutesSecondsString(seconds: playerList[indexPath.row].ConnectedSeconds)

        cell.playnameLabel.text = playerList[indexPath.row].DisplayName
        cell.playerConnected.text = "\(connectedString)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
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
}
