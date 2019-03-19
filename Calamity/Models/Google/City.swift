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
    
    var initPeopleCount: Int = 0 {
        didSet {
            currPeopleCount = initPeopleCount
        }
    }
    
    @objc private var parsedInitPeopleCount: String? {
        didSet {
            guard let parsedValue = parsedInitPeopleCount else {
                initPeopleCount = 0
                return
            }
            
            initPeopleCount = Int(parsedValue) ?? 0
        }
    }
    
    var currPeopleCount: Int = 0
    var currentDanger: Danger? = nil

    var type: CityType = .capital
    
    @objc private var parsedType: String? {
        didSet {
            guard let parsedValue = parsedType else { return }
            type = CityType(rawValue: Int(parsedValue) ?? UndefValue) ?? .capital
        }
    }
    
    var cityInDanger: Bool {
        return (nil != currentDanger)
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id",
            "name": "name",
            "cityDescription": "description",
            "parsedInitPeopleCount": "people",
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
