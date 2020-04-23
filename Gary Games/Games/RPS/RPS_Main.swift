//
//  RPS_Main.swift
//  Gary Games
//
//  Created by Tom Knighton on 12/04/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import Foundation
import UIKit

class RPS_Main : UIViewController {
    
    
    @IBOutlet weak var userChoicesStack: UIStackView?
    @IBOutlet weak var opponentStack: UIStackView?
    
    var otherUserTimer = Timer()
    
    override func viewDidLoad() {
        self.userChoicesStack?.addBackgroundColour(colour: UIColor.systemGroupedBackground, rounded: 20)
        self.userChoicesStack?.removeAllArrangedSubviews()
        
        
        self.addChoiceButtons()
        self.setupOtherUserStack()
        
        self.mockGameSetup()
    }
    
    func mockGameSetup() {
        
    }
    
    
    func setupOtherUserStack() {
        let waitingSpinner : UIActivityIndicatorView = {
            let ws = UIActivityIndicatorView()
            ws.startAnimating()
            ws.style = .large
            return ws
        }()
        let waitingLabel : UILabel = {
            let wl = UILabel()
            wl.text = "Waiting for opponent"
            wl.font = UIFont(name: "Montserrat-Regular", size: 16)
            return wl
        }()
        self.opponentStack?.addArrangedSubview(waitingSpinner)
        self.opponentStack?.addArrangedSubview(waitingLabel)
        self.opponentStack?.addBackgroundColour(colour: UIColor.clear, rounded: 20)
    }
    
    func addChoiceButtons() {
        let rockButton : UIButton = {
            let b = UIButton()
            b.setTitle("", for: .normal)
            b.setImage(#imageLiteral(resourceName: "rock"), for: .normal)
            b.imageView?.contentMode = .scaleAspectFit
            b.contentVerticalAlignment = .fill; b.contentHorizontalAlignment = .fill
            b.heightAnchor.constraint(equalToConstant: 190).isActive = true
            b.layer.shadowColor = UIColor.systemGray.cgColor
            b.layer.shadowOpacity = 1
            b.layer.shadowRadius = 15
            return b
        }()
       let paperButton : UIButton = {
            let b = UIButton()
            b.setTitle("", for: .normal)
            b.setImage(#imageLiteral(resourceName: "paper"), for: .normal)
            b.imageView?.contentMode = .scaleAspectFit
            b.contentVerticalAlignment = .fill; b.contentHorizontalAlignment = .fill
            b.heightAnchor.constraint(equalToConstant: 190).isActive = true
            b.layer.shadowColor = UIColor.systemGray.cgColor
            b.layer.shadowOpacity = 1
            b.layer.shadowRadius = 15
            return b
        }()
        let scissorButton : UIButton = {
            let b = UIButton()
            b.setTitle("", for: .normal)
            b.setImage(#imageLiteral(resourceName: "scissors"), for: .normal)
            b.imageView?.contentMode = .scaleAspectFit
            b.contentVerticalAlignment = .fill; b.contentHorizontalAlignment = .fill
            b.heightAnchor.constraint(equalToConstant: 190).isActive = true
            b.layer.shadowColor = UIColor.systemGray.cgColor
            b.layer.shadowOpacity = 1
            b.layer.shadowRadius = 15
            return b
        }()
        self.userChoicesStack?.addArrangedSubview(rockButton); self.userChoicesStack?.addArrangedSubview(paperButton); self.userChoicesStack?.addArrangedSubview(scissorButton)
    }
}
