//
//  webRcon.swift
//  RustRcon
//
//  Created by Louis Gornall on 20/09/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import Foundation
import Starscream

class webRcon: WebSocketDelegate {
    var delegate: webRconDelegate?
    private var serviceSocket: WebSocket
    private var receivedPlayerlists: [rconPacket]?

    
    init(url: URL) {
        self.serviceSocket = WebSocket(url: url)
        serviceSocket.delegate = self
        
    }
    
    public var isConnected: Bool{
        get{
            return serviceSocket.isConnected
        }
    }
    
    func connect() {
        serviceSocket.connect()
    }
    
    func send(message: String, identifier: Int){
        let packetToSend = rconPacket(Identifier: identifier, Message: message, Type: "WebRcon")
        let packetToSendAsJson = try! JSONEncoder().encode(packetToSend)
        serviceSocket.write(string: String(data: packetToSendAsJson, encoding: String.Encoding.utf8)!)
    }
    
    func requestListofPlayers(){
        send(message: "playerlist", identifier: 808)
    }
    func requestChatTail(){
        print("requesting chat")
        send(message: "chat.tail",identifier: 810)
    }
    func requestTime(){
        send(message: "env.time", identifier: 940)
    }
    
    func requestDecay(){
        send(message: "decay.scale", identifier: 941)
    }
    
    func requestHeliLiftime(){
        send(message: "heli.lifetimeminutes", identifier: 710)
    }
    func requestHeliGunDamage(){
        send(message: "heli.bulletDamageScale", identifier: 711)
    }
    func requestHeliGunAccuracy(){
        send(message: "heli.bulletaccuracy", identifier: 712)
    }
    func requestBannedPlayers(){
        send(message: "banlistex", identifier: 690)
    }
    
    func requestWind(){
        send(message: "weather.wind", identifier: 225)
    }
    
    func requestFog(){
        send(message: "weather.fog", identifier: 226)
    }
    func requestRain() {
        send(message: "weather.rain", identifier: 227)
    }
    func requestClouds() {
        send(message: "weather.clouds", identifier: 228)
    }
    func requestMaxPlayers(){
        send(message: "server.maxplayers", identifier: 100)
    }
    
    func parseBanplayer(txt: String) -> [bannedPlayer]{
        var bannedPlayerList: [bannedPlayer] = []
        let regexString : String = "\\d\\s([0-9]{10,})\\s\"(.{1,})\"\\W\"(.{2,})\""

        let regex = try! NSRegularExpression(pattern: regexString, options: [])
        let matches = regex.matches(in: txt, options: [], range: NSRange(location: 0, length: txt.count))
        
        for match in matches{
            let steamIDCapture = match.range(at: 1)
            let playerNameCapture = match.range(at: 2)
            let reasonCapture = match.range(at: 3)
           // let steamID = String(txt[steamIDRange!]) //txt[steamIDCapture.location ... steamIDCapture.length]
            let steamID = String(txt[Range.init(steamIDCapture, in: txt)!])
            let playerName = String(txt[Range.init(playerNameCapture, in: txt)!])
            let reason = String(txt[Range.init(reasonCapture, in: txt)!])
            
            if bannedPlayerList.isEmpty {
                bannedPlayerList = [bannedPlayer(playerName: playerName, SteamID: steamID, Reason: reason)]
            } else {
                bannedPlayerList.append(bannedPlayer(playerName: playerName, SteamID: steamID, Reason: reason))
            }
        }
        return bannedPlayerList
    }
    
    func parseWeather(type: String, message: String){
        let weatherComponents = message.components(separatedBy: " ")
        var weatherValueString : String = weatherComponents[3]
        weatherValueString.remove(at: weatherValueString.index(of: ")")!)
        
        if weatherValueString == "automatic" {
            print("it equalled ",weatherValueString)
            delegate?.didReceiveWeather(value: weatherValueString, type: type)
        } else {
            weatherValueString.remove(at: weatherValueString.index(of: "%")!)
            print("this is what it is:  ",weatherValueString)
            var weatherValueInt: Double = Double(weatherValueString)!
            weatherValueInt = weatherValueInt / 100
            print(weatherValueInt)
            send(message: "\(type) \(weatherValueInt)", identifier: 99)
            delegate?.didReceiveWeather(value: "\(weatherValueInt)", type: type)
            
        }
        
    }
    
    func createChatString(chatMessage :chatMsg) -> NSMutableAttributedString {
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15.0)]
        let dteformatter = DateFormatter()
        dteformatter.dateFormat = "HH:mm:ss"
        let msgTime = dteformatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(chatMessage.Time)) as Date)
        let formattedChatMsg: NSString = "\(msgTime) \(chatMessage.Username):\n\(chatMessage.Message) \n" as NSString
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedChatMsg as String as String)
        attributedString.addAttributes(boldFontAttribute, range: formattedChatMsg.range(of:"\(msgTime) \(chatMessage.Username):"))
        
        
        return attributedString
    }

    
    func parseChatTail(chatTailPacket: rconPacket){
        var chatMessages: [NSMutableAttributedString] = []
        let jsonData = chatTailPacket.Message.data(using: .utf8)!
        
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: Any]]
            for msg in json{
                if chatMessages.isEmpty{
                    let chatMsgToAdd: chatMsg = chatMsg(Message: msg["Message"] as! String, UserId: msg["UserId"] as! Int, Username: msg["Username"] as! String, Color: msg["Color"] as! String , Time: msg["Time"] as! Int)
                    
                    if !UserDefaults.standard.bool(forKey: "chatTail_includeServer") && chatMsgToAdd.UserId < 1{
                        print("this should have something 1")
                    } else {
                        
                        chatMessages = [createChatString(chatMessage: chatMsgToAdd)]
                    }
                } else {
                    let chatMsgToAdd: chatMsg = chatMsg(Message: msg["Message"] as! String, UserId: msg["UserId"] as! Int, Username: msg["Username"] as! String , Color: msg["Color"] as! String , Time: msg["Time"] as! Int)
                    
                    if !UserDefaults.standard.bool(forKey: "chatTail_includeServer") && chatMsgToAdd.UserId < 1{
                        print("this should have something")
                    } else {
                       
                        print(chatMsgToAdd)
                       chatMessages.append(createChatString(chatMessage: chatMsgToAdd))
                    }
                    
                }
                
            }
        } catch let error as NSError{
            print("Failed to load: \(error.localizedDescription)")
        }
        
        delegate?.didReceiveChatTail(chatMsgs: chatMessages)
        
        
    }
    
    func parseChatMsg(msg: String) -> chatMsg {
        let jsonData = msg.data(using: .utf8)
        
        let decoder = JSONDecoder()
        let receivedChatMsg = try! decoder.decode(chatMsg.self, from: jsonData!)
        
        return receivedChatMsg
    }
    
    func updateListOfPlayers(playerlistMessage: rconPacket) {
        var playerList : [player] = []
        
        let jsonData = playerlistMessage.Message.data(using: .utf8)!
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: Any]]
            for playerr in json {
                if (playerList.isEmpty){
                    let playerToAdd: player = player(SteamID: playerr["SteamID"] as! String, OwnerSteamID: playerr["OwnerSteamID"] as! String, DisplayName: playerr["DisplayName"] as! String, Ping: playerr["Ping"] as! Int, Address: playerr["Address"] as! String, ConnectedSeconds: playerr["ConnectedSeconds"] as! Int, VoiationLevel: playerr["VoiationLevel"] as! Float, CurrentLevel: playerr["CurrentLevel"] as! Float, UnspentXP: playerr["UnspentXp"] as! Float, Health: playerr["Health"] as! Float)
                    playerList = [playerToAdd]
                } else {
                    let playerToAdd: player = player(SteamID: playerr["SteamID"] as! String, OwnerSteamID: playerr["OwnerSteamID"] as! String, DisplayName: playerr["DisplayName"] as! String, Ping: playerr["Ping"] as! Int, Address: playerr["Address"] as! String, ConnectedSeconds: playerr["ConnectedSeconds"] as! Int, VoiationLevel: playerr["VoiationLevel"] as! Float, CurrentLevel: playerr["CurrentLevel"] as! Float, UnspentXP: playerr["UnspentXp"] as! Float, Health: playerr["Health"] as! Float)
                    
                    playerList.append(playerToAdd)
                }
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        delegate?.playerListUpdated(playerList: playerList)
    }
    
    func websocketDidConnect(socket: WebSocket) {
        delegate?.didConnect()
        requestMaxPlayers()
        requestListofPlayers()
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
            
        } else {
            print("websocket disconnected")
        }
        delegate?.socketWasDisconnected()
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        let jsonData = text.data(using: .utf8)!
        let decoder = JSONDecoder()
        let receivedRconPacket = try! decoder.decode(rconPacket.self, from: jsonData)
        if receivedRconPacket.Identifier == 808{
            //808 is list of players
            updateListOfPlayers(playerlistMessage: receivedRconPacket)
        } else if(receivedRconPacket.Identifier == 940){
            //940 is env time .
            var floatString = receivedRconPacket.Message.components(separatedBy: "\"")
            
            let timeAsFloat: Float = Float(floatString[1])!
            print("received time " , receivedRconPacket.Message, " ", timeAsFloat )
            delegate?.didReceiveTime(value: timeAsFloat)
            
        }else if(receivedRconPacket.Identifier == 941){
            //941 is for decay
            var floatString = receivedRconPacket.Message.components(separatedBy: "\"")
            let decayAsDouble: Double = Double(floatString[1])!
            
            delegate?.didReceiveDecay(value: decayAsDouble)
            
        } else if receivedRconPacket.Identifier == 710{
            //heli lifetime
            var floatString = receivedRconPacket.Message.components(separatedBy: "\"")
            let stringtoFloat: Float = Float(floatString[1])!
            
            delegate?.didReceiveHeliLifetime(value: stringtoFloat)
        }else if receivedRconPacket.Identifier == 711{
            //heli damage
            var floatString = receivedRconPacket.Message.components(separatedBy: "\"")
            let stringtoFloat: Float = Float(floatString[1])!
            
            delegate?.didReceiveHeliBulletDmg(Value: stringtoFloat)
            
        }else if receivedRconPacket.Identifier == 712{
            //heli accuracy
            var floatString = receivedRconPacket.Message.components(separatedBy: "\"")
            let stringtoFloat: Float = Float(floatString[1])!
            
            delegate?.didReceiveHeliAccuracy(value: stringtoFloat)
            
        }else if receivedRconPacket.Identifier == 690{
            //banned players
            delegate?.didReceiveBannedPLayers(bannedPlayerList: parseBanplayer(txt: receivedRconPacket.Message))
        }else if receivedRconPacket.Identifier == 225{
            //wind
            parseWeather(type: "weather.wind", message: receivedRconPacket.Message)
        }else if receivedRconPacket.Identifier == 226{
            //fog
            parseWeather(type: "weather.fog", message: receivedRconPacket.Message)
        }else if receivedRconPacket.Identifier == 227{
            //rain
            parseWeather(type: "weather.rain", message: receivedRconPacket.Message)
        }else if receivedRconPacket.Identifier == 228{
            //clouds
            parseWeather(type: "weather.clouds", message: receivedRconPacket.Message)
        }else if receivedRconPacket.Identifier == 100{
            //maxplayers
            var maxPlayerString = receivedRconPacket.Message.components(separatedBy: "\"")           
            delegate?.didReceiveMaxPlayers(maxPlayers: Int(maxPlayerString[1])!)
            
            
        }else if receivedRconPacket.Identifier == 810 {
            //chattail
            print("chattrailreceived")
            parseChatTail(chatTailPacket: receivedRconPacket)
            
        }else if receivedRconPacket.Type == "Chat" && !UserDefaults.standard.bool(forKey: "console_includeChat") {
        } else {
            delegate?.didReceiveMessage(message: receivedRconPacket)
        }
        
        //print("rustrcon packet type \(receivedRconPacket.Type) and \(receivedRconPacket.Message)")
        if (receivedRconPacket.Type == "Chat") {
            print("Chat Messge received \(receivedRconPacket.Message)")
            
            let parsedChatMsg = parseChatMsg(msg: receivedRconPacket.Message)
            let chatString: NSMutableAttributedString = createChatString(chatMessage: parsedChatMsg)

            
            delegate?.didReceiveChatMessage(chatMsg: chatString)
        }
        
    }
    func disconnect(){
        _ = WebSocket.disconnect(serviceSocket)
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        //print("data rec", data)
    }
    
}

protocol webRconDelegate {
    func didReceiveMaxPlayers(maxPlayers: Int)
    func didReceiveMessage(message: rconPacket)
    func playerListUpdated(playerList: [player])
    func didConnect()
    func socketWasDisconnected()
    func didReceiveChatMessage(chatMsg: NSMutableAttributedString)
    func didReceiveChatTail(chatMsgs: [NSMutableAttributedString])
    func didReceiveTime(value: Float)
    func didReceiveDecay(value: Double)
    func didReceiveHeliAccuracy(value: Float)
    func didReceiveHeliLifetime(value: Float)
    func didReceiveHeliBulletDmg(Value: Float)
    func didReceiveBannedPLayers(bannedPlayerList: [bannedPlayer])
    func didReceiveWeather(value:String, type: String)
}


struct bannedPlayer: Codable{
    var playerName : String
    var SteamID : String
    var Reason : String
}

struct chatMsg: Codable {
    var Message: String
    var UserId: Int
    var Username: String
    var Color: String
    var Time : Int
    
}

struct rconPacket: Codable {
    var Identifier: Int
    var Message: String
    var `Type`: String
}

struct player: Codable {
    var SteamID: String
    var OwnerSteamID: String
    var DisplayName: String
    var Ping: Int
    var Address: String
    var ConnectedSeconds: Int
    var VoiationLevel: Float
    var CurrentLevel: Float
    var UnspentXP: Float
    var Health: Float
}

