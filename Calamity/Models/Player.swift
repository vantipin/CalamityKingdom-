//
//  Player.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Player {
    var name = ""
    
    var playerProfileIcon = ""
    var mana: Int
    var kingRep: Int
    var peopleRep: Int
    var corrupt: Int
    
    func initialize() {
        guard let constants = Game.instance.gameConstants,
            let plMana = constants.mana,
            let kRep = constants.king_rep,
            let pRep = constants.people_rep,
            let corr = constants.corrupt else {
                mana = 0
                kingRep = 0
                peopleRep = 0
                corrupt = 0
                return
        }
        
        mana = plMana.constValue
        kingRep = kRep.constValue
        peopleRep = pRep.constValue
        corrupt = corr.constValue
    }
    
    init() {
        mana = 0
        kingRep = 0
        peopleRep = 0
        corrupt = 0
    }
}
