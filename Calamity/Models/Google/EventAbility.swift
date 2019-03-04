//
//  EventAbility.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/5/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class EventAbility: GoogleBaseModel {
    var eventId = ""
    var cost: Int = 0
    
    var abilityName = ""
    var abilityDescription = ""
    
    var mana: Int = 0
    var kingRep: Int = 0
    var peopleRep: Int = 0
    var corrupt: Int = 0
    
    var ending: Int = 0
  
    override func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "eventId" : "id_event",
            "identifier" : "id_reply",
            "abilityName" : "text",
            "abilityDescription": "result",
            "mana" : "mana",
            "kingRep" : "king_rep",
            "peopleRep" : "people_rep",
            "corrupt" : "corrupt",
            "ending" : "ending",
            "cost" : "cost"
        ]
    }
}
