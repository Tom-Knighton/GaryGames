//
//  MainPageGamesModel.swift
//  Gary Games
//
//  Created by Tom Knighton on 11/04/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

class MainPageGamesModel : NSObject, UICollectionViewDataSource {
    
    static let gameTypes : [GameType] = [GameType(GameName: "Gary Jitsu", GameImageURL: "https://cdn.tomk.online/EduChat.png"),
                                  GameType(GameName: "Rock, Paper, Scissors", GameImageURL: "https://static.vecteezy.com/system/resources/thumbnails/000/691/489/original/retro-offset-rock-paper-scissors-icons.jpg")]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainPageGamesModel.gameTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? MainPageGamesCell else { return UICollectionViewCell() }
        cell.populate(with: MainPageGamesModel.gameTypes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GamesHeader", for: indexPath)
        default:
            assert(false, "Unrecognised"); return UICollectionReusableView()
        }
    }

}
