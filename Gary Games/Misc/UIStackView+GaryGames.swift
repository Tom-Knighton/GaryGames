//
//  UIStackView+GaryGames.swift
//  Gary Games
//
//  Created by Tom Knighton on 12/04/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func addBackgroundColour(colour: UIColor, rounded: CGFloat = 0) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = colour
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subview.layer.cornerRadius = rounded; subview.layer.masksToBounds = true
        subview.layer.shadowRadius = rounded
        subview.layer.shadowColor = UIColor.lightGray.cgColor
        subview.layer.shadowOpacity = (rounded == 0 ? 0 : 1)
        insertSubview(subview, at: 0)
    }
}
