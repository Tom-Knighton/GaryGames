//
//  Game.swift
//  Gary Games
//
//  Created by Tom Knighton on 11/04/2020.
//  Copyright © 2020 Tom Knighton. All rights reserved.
//

import UIKit

struct GameType {
    var GameName : String?
    var GameImageURL : String?
}

struct CardGameMove : Codable {
    var pId : String?
    var card : Int?
}

struct CardGamePlayer : Codable {
    var playerId : String?
    var score: Int?
}


protocol Game {
    //TODO: Fill In
}


struct Game_RPS : Game {
    var GUID : String?
    var HasStarted : Bool?
    var Players : [GamePlayer_RPS]?
    
}
struct GamePlayer_RPS {
    var ConnectionId : String?
}


