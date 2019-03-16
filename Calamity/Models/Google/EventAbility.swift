//
//  EventAbility.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/5/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class EventAbility: GoogleBaseModel {
    @objc var eventId = ""
    @objc var cost: Int = 0
    
    @objc var abilityName = ""
    @objc var abilityDescription = ""
    
    @objc var mana: Int = 0
    @objc var kingRep: Int = 0
    @objc var peopleRep: Int = 0
    @objc var corrupt: Int = 0
    
    @objc var ending: Int = 0
  
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
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
    
    @objc static func jsonTransformer(forKey key: String!) -> ValueTransformer! {
        let keysToTransform = ["cost",
                               "mana",
                               "kingRep",
                               "peopleRep",
                               "corrupt",
                               "ending"]
        
        if keysToTransform.contains(key) {
            return Ability.intTransformer()
        }
        
        return ValueTransformer()
    }
}
