//
//  City.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class City: GoogleBaseModel {
    @objc var name: String = ""
    @objc var cityDescription: String = ""
    
    @objc var initPeopleCount: Int = 0 {
        didSet {
            currPeopleCount = initPeopleCount
        }
    }
    
    var currPeopleCount: Int = 0
    var currentDanger: Danger? = nil
    var type: DangerType {
        get {
            return DangerType(rawValue: parsedType?.intValue ?? UndefValue) ?? .disaster
        }
        set {
            parsedType = NSNumber(value: type.rawValue)
        }
    }
    
    @objc private var parsedType: NSNumber?
    
    var cityInDanger: Bool {
        return (nil != currentDanger)
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id",
            "name": "name",
            "cityDescription": "description",
            "initPeopleCount": "people",
            "parsedType" : "type"
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
            died = Int(min(CGFloat(result.defaultDieCoef) * CGFloat(initPeopleCount), CGFloat(currPeopleCount)))
        } else {
            died = Int(min(CGFloat(result.defaultDieCoef) * CGFloat(initPeopleCount), CGFloat(currPeopleCount)))
        }
        
        currPeopleCount -= died
        danger.removed = true
        
        return died
    }
}
