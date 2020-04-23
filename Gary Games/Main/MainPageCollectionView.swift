//
//  MainPageCollectionView.swift
//  Gary Games
//
//  Created by Tom Knighton on 11/04/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class MainPageCollectionView: UICollectionView, UICollectionViewDelegate {

    var GamesDelegate : GamesListDelegate?
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.bounds.width, height: 54)
    }
}

extension MainPageCollectionView : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = MainPageGamesModel.gameTypes[indexPath.row]
        self.GamesDelegate?.GameSelected(game)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width / 2) - 12, height: (self.frame.width / 2) - 12)
    }
}

