//
//  GamesHub.swift
//  Gary Games
//
//  Created by Tom Knighton on 12/04/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import Foundation
import SwiftSignalRClient

class GamesHub : NSObject, HubConnectionDelegate {

    
    static let sharedInstance = GamesHub()
    
    private let hubURL = "https://localhost:5624/GamesHub"
    private let dispatchQueue = DispatchQueue(label: "garygames.gamesqueue.dispatchqueue")
    
    private var hubConnection: HubConnection?
    private var hubConnectionDelegate: HubConnectionDelegate?
    
    override init() { super.init() }
    
    
    func setupConnection() {
        self.hubConnectionDelegate = self
        self.hubConnection = HubConnectionBuilder(url: URL(string: hubURL)!)
            .withLogging(minLogLevel: .debug)
            .withHubConnectionDelegate(delegate: self.hubConnectionDelegate!)
            .withHttpConnectionOptions(configureHttpOptions: { (o) in
                o.skipNegotiation = true
            })
            .build()
        self.hubConnection?.delegate = self
       
        self.listenForMessages()
        
        self.hubConnection?.start()
    }
    
    
    func listenForMessages() {
        self.hubConnection?.on(method: "RecieveTestMessage", callback: {(message: String) in
           do {
               let dataDict : [String: Any] = ["msg": message]
               NotificationCenter.default.post(Notification(name: .TestMsgReceived, object: self, userInfo: dataDict))
           }
        })
        self.hubConnection?.on(method: "Connected", callback: {(id: String) in
           do {
               let dataDict : [String: Any] = ["id": id]
               NotificationCenter.default.post(name: .GameIdentityCreated, object: self, userInfo: dataDict)
           }
        })

        self.hubConnection?.on(method: "StartGame", callback: { (GroupId: String, p1: String, p2: String) in
           do {
               let dataDict : [String: Any] = ["gId": GroupId, "p1": p1, "p2": p2]
               NotificationCenter.default.post(name: .StartGame, object: self, userInfo: dataDict)
           }
        })
        self.hubConnection?.on(method: "RoundFinished", callback: {(type: String, round: Int, p1Move: String, p2Move: String) in
            let decoder = JSONDecoder()
            do {
                let move1 = try decoder.decode(CardGameMove.self, from: p1Move.data(using: .utf8)!)
                let move2 = try decoder.decode(CardGameMove.self, from: p2Move.data(using: .utf8)!)
                let dataDict : [String: Any] = ["type": type, "p1Move": move1, "p2Move": move2, "round": round]
                NotificationCenter.default.post(name: .MovePlayed, object: self, userInfo: dataDict)
            }
            catch {
                print("Err converting to json")
            }
        })
        
        self.hubConnection?.on(method: "GameFinished", callback: {(p1: String, p2: String) in
            let decoder = JSONDecoder()
            do {
                let player1 = try decoder.decode(CardGamePlayer.self, from: p1.data(using: .utf8)!)
                let player2 = try decoder.decode(CardGamePlayer.self, from: p2.data(using: .utf8)!)
                let dataDict : [String: Any] = ["p1": player1, "p2": player2]
                NotificationCenter.default.post(name: .GameFinished, object: self, userInfo: dataDict)

            }
            catch { print("ERR CONVERTING JSON") }
        })
        
        self.hubConnection?.on(method: "GameFinishedForfeit", callback: {(p1: String, p2: String, quitter: String) in
            let decoder = JSONDecoder()
            do {
                let player1 = try decoder.decode(CardGamePlayer.self, from: p1.data(using: .utf8)!)
                let player2 = try decoder.decode(CardGamePlayer.self, from: p2.data(using: .utf8)!)
                let dataDict : [String: Any] = ["p1": player1, "p2": player2, "quitter": quitter]
                NotificationCenter.default.post(name: .GameQuit, object: self, userInfo: dataDict)
                print("posted ^ .gameQuit")
            }
            catch { print("ERR CONVERTING JSON") }
        })
    }
    
    func testForfeitGame(group: String) {
        self.hubConnection?.invoke(method: "ForfeitGame") { error in
            if let e = error { print(e) }
        }
    }
    func sendTestMessage(msg : String) {
        self.hubConnection?.invoke(method: "SendTestMessage", msg) { error in
            if let e = error { print(e) }
        }
    }
    
    func testConnectTo(id1: String, id2: String) {
        self.hubConnection?.invoke(method: "ConnectTo", id1, id2) { error in
            if let e = error { print(e) }
        }
    }
    
    func testPlayMove(card: Int, group: String) {
        self.hubConnection?.invoke(method: "PlayCard", card, group) { error in
            if let e = error { print(e) }
        }
    }
    
    func getConnId() -> String {
        return hubConnection?.connectionId ?? ""
    }
    
    func connectionDidOpen(hubConnection: HubConnection) {
        print("Opened")
        print(":+ "+(self.getConnId()))
    }
    
    func connectionDidFailToOpen(error: Error) {
        print("conn fail")
    }
    
    func connectionDidClose(error: Error?) {
        print("conn close")
    }
    
}

extension Notification.Name {
    static let TestMsgReceived = Notification.Name("TestMsgReceived")
    static let GameIdentityCreated = Notification.Name("GameIdentityCreated")
    static let StartGame = Notification.Name("StartGame")
    static let MovePlayed = Notification.Name("MovePlayed")
    static let GameFinished = Notification.Name("GameFinished")
    static let GameQuit = Notification.Name("GameQuit")
    static let AppWillTerminate = Notification.Name("AppWillTerminate")
}
