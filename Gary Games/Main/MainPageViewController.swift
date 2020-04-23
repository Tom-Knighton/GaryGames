//
//  MainPageViewController.swift
//  Gary Games
//
//  Created by Tom Knighton on 11/04/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

protocol GamesListDelegate {
    func GameSelected(_ game: GameType)
}

class MainPageViewController: UIViewController, GamesListDelegate {
  
    
    let gamesModel = MainPageGamesModel()
    
    @IBOutlet weak var gamesCollectionView: MainPageCollectionView!
    @IBOutlet weak var gamesCollectionViewFlow: UICollectionViewFlowLayout?
    
    override func viewDidLoad() {
        self.gamesCollectionView.delegate = self.gamesCollectionView
        self.gamesCollectionView.dataSource = self.gamesModel
        self.gamesCollectionViewFlow?.estimatedItemSize = .zero
        self.gamesCollectionViewFlow?.sectionHeadersPinToVisibleBounds = true
        self.gamesCollectionView.GamesDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tstmsg(_:)), name: .TestMsgReceived, object: nil)
    }
    
    @objc func tstmsg(_ notification: NSNotification) {
        if let msg = notification.userInfo?["msg"] as? String {
            let alert = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func GameSelected(_ game: GameType) {
        if game.GameName == "Rock, Paper, Scissors" {
            let vc = self.storyboard?.instantiateViewController(identifier: "RPS_Main")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
      
    
}

