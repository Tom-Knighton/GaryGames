//
//  GameTest.swift
//  Gary Games
//
//  Created by Tom Knighton on 12/04/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import Foundation
import UIKit

class GameTest : UIViewController {
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var conn1Label: UILabel!
    @IBOutlet weak var conn2Label: UILabel!
    @IBOutlet weak var meLabel: UILabel!
    @IBOutlet weak var meScoreLabel: UILabel!
    @IBOutlet weak var p2ScoreLabel: UILabel!
    @IBOutlet weak var mePlayedLabel: UILabel!
    @IBOutlet weak var p2PlayedLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    var myScore = 0;
    var otherScore = 0;
    
    var groupId: String?
    
    var myId : String?
    
    var roundTimer = Timer()
    
    var cardPicked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.connectedToHub(_:)), name: .GameIdentityCreated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startedGame(_:)), name: .StartGame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.movePlayed(_:)), name: .MovePlayed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gameFinished(_:)), name: .GameFinished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gameQuit(_:)), name: .GameQuit, object: nil)
        self.meLabel.text = "You are: \(GamesHub.sharedInstance.getConnId()) :)"
    }
    
    func runRoundTimer() {
        var secondsLeft = 10
        self.timeLabel.text = "Time: 10 seconds"
        self.roundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            secondsLeft -= 1
            self.timeLabel.text = "Time: \(secondsLeft) seconds"
            if (secondsLeft < 0 && self.cardPicked == false){
                let card = Int.random(in: 0...12)
                GamesHub.sharedInstance.testPlayMove(card: card, group: self.groupId ?? "")
                t.invalidate(); self.roundTimer.invalidate()
                self.roundTimer = Timer()
            }
        }
    }
    
    @objc func connectedToHub(_ notification: NSNotification) {
        print("CONNECTED HUB")
        if let id = notification.userInfo?["id"] as? String {
            self.meLabel.text = "You are: \(id) :)"
            self.myId = id
        }
        
        
    }
    
    @objc func startedGame(_ notification: NSNotification) {
        if let gId = notification.userInfo?["gId"] as? String {
            let p1 = notification.userInfo?["p1"] as? String; let p2 = notification.userInfo?["p2"] as? String
            self.gameLabel.text = "Game: "+gId+" STARTED"
            self.conn1Label.text = "Conn 1: " + (p1 ?? "")
            self.conn2Label.text = "Conn 2: " + (p2 ?? "")
            self.groupId = gId
            
            self.runRoundTimer()
        }
    }
    
    
    @objc func willTerminate(_ notification: NSNotification) {
        print("t2")
        GamesHub.sharedInstance.testForfeitGame(group: self.groupId ?? "")
    }
    @objc func movePlayed(_ notification: NSNotification) {
        if let type = notification.userInfo?["type"] as? String {
            guard let move1 = notification.userInfo?["p1Move"] as? CardGameMove else { return }
            guard let move2 = notification.userInfo?["p2Move"] as? CardGameMove else { return }
            guard let round = notification.userInfo?["round"] as? Int else {
                return
            }
            self.roundTimer.invalidate(); self.roundTimer = Timer()
            self.cardPicked = false
            let moves : [CardGameMove] = [move1, move2]
            
            let myPlay = moves.first(where: { $0.pId == self.myId ?? ""})
            let otherPlay = moves.first(where: { $0.pId != self.myId ?? "" })
            if type.lowercased() == "draw" {
                myScore += 1; otherScore += 1;
                self.statusLabel.text = "Draw! \(myPlay?.card ?? 0) vs \(otherPlay?.card ?? 0)"
                self.mePlayedLabel.text = "You Played: \(myPlay?.card ?? 0)"; self.p2PlayedLabel.text = "P2 Played: \(otherPlay?.card ?? 0)"
                self.meScoreLabel.text = "Your score: \(self.myScore)"
                self.p2ScoreLabel.text = "P2 score: \(self.otherScore)"
            }
            else if type.lowercased() == "win" {
                self.myScore += 1;
                self.statusLabel.text = "You Win! \(myPlay?.card ?? 0) vs \(otherPlay?.card ?? 0)"
                self.mePlayedLabel.text = "You Played: \(myPlay?.card ?? 0)"; self.p2PlayedLabel.text = "P2 Played: \(otherPlay?.card ?? 0)"
                self.meScoreLabel.text = "Your Score: \(self.myScore)"
            }
            else {
                self.otherScore += 1;
                self.statusLabel.text = "You Lose :( \(myPlay?.card ?? 0) vs \(otherPlay?.card ?? 0)"
                self.mePlayedLabel.text = "You Played: \(myPlay?.card ?? 0)"; self.p2PlayedLabel.text = "P2 Played: \(otherPlay?.card ?? 0)"
                self.p2ScoreLabel.text = "P2 score: \(self.otherScore) "
            }
            if (round <= 9) { self.roundLabel.text = "Round: \(round+1)" }
            self.runRoundTimer()
        }
    }
    
    @objc func gameFinished(_ notification: NSNotification) {
        if let p1 = notification.userInfo?["p1"] as? CardGamePlayer {
            guard let p2 = notification.userInfo?["p2"] as? CardGamePlayer else { return }
            self.roundTimer.invalidate(); self.timeLabel.text = ""
            let players : [CardGamePlayer] = [p1, p2]
            self.gameLabel.text = "Game: Finished"
            let myPlayer = players.first(where: { $0.playerId == self.myId ?? "" }); let otherPlayer = players.first(where: { $0.playerId != self.myId ?? "" })
            if (myPlayer?.score ?? 0) > (otherPlayer?.score ?? 0) { //We won
                self.meScoreLabel.text = "Your Score: \(myPlayer?.score ?? 0) - WINNER"
                self.p2ScoreLabel.text = "P2 Score: \(otherPlayer?.score ?? 0) - LOSER"
                self.statusLabel.text = "WINNER!"
            }
            else if (myPlayer?.score ?? 0) < (otherPlayer?.score ?? 0) { //We lost
                self.meScoreLabel.text = "Your Score: \(myPlayer?.score ?? 0) - LOSER"
                self.p2ScoreLabel.text = "P2 Score: \(otherPlayer?.score ?? 0) - WINNER"
                self.statusLabel.text = "LOSER :("
            }
            else { //Draw
                self.meScoreLabel.text = "Your Score: \(myPlayer?.score ?? 0) - DRAW"
                self.p2ScoreLabel.text = "P2 Score: \(otherPlayer?.score ?? 0) - DRAW"
                self.statusLabel.text = "IT'S A DRAW!"
            }
        
        }
    }
    
    @objc func gameQuit(_ notification: NSNotification) {
        if let p1 = notification.userInfo?["p1"] as? CardGamePlayer {
            guard let p2 = notification.userInfo?["p2"] as? CardGamePlayer else { return }
            self.roundTimer.invalidate(); self.timeLabel.text = ""
            let players = [p1, p2]
            self.gameLabel.text = "Game: Finished"
            let myPlayer = players.first(where: { $0.playerId == self.myId ?? "" }); let otherPlayer = players.first(where: { $0.playerId != self.myId ?? "" })
            
            //Other player has lost
            self.meScoreLabel.text = "Your Score: \(myPlayer?.score ?? 0) - WINNER"
            self.p2ScoreLabel.text = "P2 Score: \(otherPlayer?.score ?? 0) - LOSER (Quit Game)"
            self.statusLabel.text = "WINNER!"
        }
    }
    
    @IBAction func pickCardPressed(_ sender: Any) {
        let cardToPlay = Int.random(in: 0...12)
        self.cardPicked = true
        self.statusLabel.text = "You picked: \(cardToPlay)"
        GamesHub.sharedInstance.testPlayMove(card: cardToPlay, group: self.groupId ?? "")
    }
    
    @IBAction func connectToButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Connect To:", message: "Enter connect id", preferredStyle: .alert)
        alert.addTextField { (tf) in
        
        }
        alert.addAction(UIAlertAction(title: "Connect", style: .default, handler: { (_) in
            guard let tf = alert.textFields?[0] as? UITextField else { return }
            GamesHub.sharedInstance.testConnectTo(id1: self.myId ?? "", id2: tf.text ?? "")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
