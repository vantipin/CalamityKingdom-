//
//  City.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class City: GoogleBaseModel {
    var name: String = ""
    var cityDescription: String = ""
    
    var initPeopleCount: Int = 0 {
        didSet {
            currPeopleCount = initPeopleCount
        }
    }
    
    var currPeopleCount: Int = 0
    var currentDanger: Danger? = nil
    var type: DangerType = .disaster
    
    var cityInDanger: Bool {
        return (nil != currentDanger)
    }
    
    override func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id",
            "name": "name",
            "cityDescription": "description",
            "initPeopleCount": "people",
            "type" : "type"
        ]
    }

    func recalculateCurrentRating(withDanger danger: Danger, abilityType: AbilityType = .nobody) -> Int {
        guard !danger.removed else {
            return 0
        }
        
        var died = 0
        let result = danger.result
        result.helpAbilityType = abilityType
        
        if abilityType == .nobody {
            died = Int(min(result.defaultDieCoef * CGFloat(initPeopleCount), CGFloat(currPeopleCount)))
        } else {
            died = Int(min(result.defaultDieCoef * CGFloat(initPeopleCount), CGFloat(currPeopleCount)))
        }
        
        currPeopleCount -= died
        danger.removed = true
        
        return died
    }
}
