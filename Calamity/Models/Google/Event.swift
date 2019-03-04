//
//  Event.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/5/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit
import Mantle

class Event: GoogleBaseModel {
    var name = ""
    var type: EventType = .nothing
    
    var days: IndexSet = IndexSet()
    var abilities: [EventAbility] = []
    
    var ifMana: Int = UndefValue
    var ifKingRep: Int = UndefValue
    var ifPeopleRep: Int = UndefValue
    var ifCorrupt: Int = UndefValue
    
    var defaultDiePercent: CGFloat = 0
    var eventDescription: String = ""
    
    var dayString: String = "" {
        didSet {
            let numbers = dayString.components(separatedBy: ", ")
            
            if numbers.count == 2 {
                let min = Int(numbers[0]) ?? 0
                let max = Int(numbers[1]) ?? 0
                let dayRange = min...max
                days = IndexSet(integersIn: dayRange)
            } else if numbers.count == 1 {
                let min = Int(numbers[0]) ?? 0
                days = IndexSet(integer: min)
            }
        }
    }

    override func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id",
            "name" : "name",
            "type" : "type",
            "dayString" : "day",
            "ifMana" : "if_mana",
            "ifKingRep" : "if_king_rep",
            "ifPeopleRep" : "if_people_rep",
            "ifCorrupt" : "if_corrupt",
            "eventDescription" : "description",
        ]
    }
    
    class func zeroTransformer() -> ValueTransformer {
        return MTLValueTransformer(usingForwardBlock: { (value, _, _) -> Any? in
            guard let str = value as? String, str.count > 0 else { return NSNumber(value: UndefValue) }
            return NSNumber(value: Int(str) ?? UndefValue)
        }, reverse: { (value, _, _) -> Any? in
            guard let eventValue = value as? NSNumber else { return "" }
            return eventValue.intValue != UndefValue ? "\(eventValue)" : ""
        })
    }

    static func jsonTransformer(forKey key: String!) -> ValueTransformer! {
        let keysToTransform = ["if_mana",
                               "if_king_rep",
                               "if_people_rep",
                               "if_corrupt"]
        
        if keysToTransform.contains(key) {
            return Event.zeroTransformer()
        }
        
        return ValueTransformer()
    }
    
    func eventTypeIcon() -> UIImage {
        return type.iconImage()
    }
    
    func appendAbility(ability: EventAbility) {
        self.abilities.append(ability)
    }
}
