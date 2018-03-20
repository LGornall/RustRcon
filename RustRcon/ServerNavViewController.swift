//
//  ServerNavViewController.swift
//  RustRcon
//
//  Created by Louis Gornall on 10/10/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit

class ServerNavViewController: UINavigationController, webRconDelegate {

    func disconnectFromServer(id: Any ){
         
    }

    var playerList: [player] = []
    var targetServer: Server?
    
    var rconnection: webRcon?
    
    var receivedMessages: [String]?
    var receivedChatMessages: [NSMutableAttributedString]?
    
    var chatViewController: chatView?
    var maintabBarController : tabBarCon?
    var bannedPlayerViewDelegate: bannedPlayerView?
    var consoleViewdelegate: consoleView?
    var playerViewDelegate: playersView?
    var maintenanceViewDelegate: maintenanceView?
    var eventViewDelegate: eventsView?
    var weatherViewDelegate: weatherView?
    func connectToServer(){
        let ipAddress: String = (targetServer!.value(forKey: "ipaddress") as? String)!
        let port: String = "\(targetServer!.value(forKey: "port") as! Int64)"
        let password: String = (targetServer!.value(forKey: "password") as? String)!
        
        let connectionString: String = "ws://\(ipAddress):\(port)/\(password)"
        let connectionUrl: URL = URL(string: connectionString)!
        
        rconnection = webRcon(url: connectionUrl)
        rconnection?.connect()
        rconnection?.delegate = self
    }
    
    func didReceiveTime(value: Float) {
        maintenanceViewDelegate?.timeFetched(value: value)
        
    }
    
    func didReceiveDecay(value: Double) {
        maintenanceViewDelegate?.decayFetched(value: value)
    }
    
    func didReceiveBannedPLayers(bannedPlayerList: [bannedPlayer]) {
        bannedPlayerViewDelegate?.bannedPlayersFetched(bannedPlayers: bannedPlayerList)
    }
    func didReceiveChatTail(chatMsgs: [NSMutableAttributedString]) {
       chatViewController?.chatTailReceived(chatTail: chatMsgs)
    }
    
    func socketWasDisconnected() {
        print("WARNING DISCONNECTED")
        let disconnectedAlertController = UIAlertController(title: "Disconnected :(", message: "Couldn't connect to the Rust Server", preferredStyle: UIAlertControllerStyle.alert)
        disconnectedAlertController.addAction(UIAlertAction(title: "Reconnect", style: UIAlertActionStyle.default, handler: {ACTION in
            self.connectToServer()
            self.maintabBarController?.connecting()

        }))
        disconnectedAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:{ ACTION in
                self.dismiss(animated: true, completion: nil)
        }))
        self.present(disconnectedAlertController, animated: true, completion: nil)
        
        //performSegue(withIdentifier:"backToServerSelectSegue", sender: Any.self)
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    func didReceiveHeliAccuracy(value: Float) {
        eventViewDelegate?.heliAccuracyFetched(value: value)
    }
    
    func didReceiveHeliLifetime(value: Float) {
        eventViewDelegate?.heliLifeTimeFetched(value: value)
    }
    
    func didReceiveHeliBulletDmg(Value: Float) {
        eventViewDelegate?.heliBulletDmgFetched(value: Value)
    }
    
    func didReceiveChatMessage(chatMsg: NSMutableAttributedString) {
        if receivedChatMessages == nil {
            receivedChatMessages = [chatMsg]
        } else {
            receivedChatMessages?.append(chatMsg)
        }
        
        chatViewController?.chatMessageReceived(chatMsgs: receivedChatMessages!)
    }
    
    func didReceiveMaxPlayers(maxPlayers: Int) {
        playerViewDelegate?.maxPlayersreceived(maxPlayers: maxPlayers)
    }
    
    
    func didReceiveMessage(message: rconPacket) {
        if receivedMessages == nil {
            receivedMessages = [message.Message]
        } else {
            receivedMessages?.append(message.Message)
        }
        
        consoleViewdelegate?.messageReceived(messages: receivedMessages!)
    }
    func didReceiveWeather(value: String, type: String) {
        weatherViewDelegate?.didReceiveWeather(value: value, type: type)
    }
    
    func playerListUpdated(playerList: [player]) {
        playerViewDelegate?.playersUpdated(players: playerList)
    }
    
    func didConnect() {
        maintabBarController?.didConnect()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToServer()
        self.rconnection?.requestChatTail()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

protocol chatView {
    func chatMessageReceived(chatMsgs: [NSMutableAttributedString])
    func chatTailReceived(chatTail: [NSMutableAttributedString])
}

protocol tabBarCon {
    func didConnect()
    func connecting()
}

protocol weatherView {
    func didReceiveWeather(value: String, type: String)
}

protocol bannedPlayerView {
    func bannedPlayersFetched(bannedPlayers: [bannedPlayer])
}

protocol eventsView{
    func heliAccuracyFetched(value: Float)
    func heliLifeTimeFetched(value: Float)
    func heliBulletDmgFetched(value: Float)
}

protocol maintenanceView {
    func timeFetched(value: Float)
    func decayFetched(value: Double)
}

protocol playersView {
    func playersUpdated(players: [player])
    func maxPlayersreceived(maxPlayers: Int)
}

protocol consoleView {
    func messageReceived(messages: [String])
}

protocol rconConnectionHandler {
    func sendMessage(message:String)
    
}
