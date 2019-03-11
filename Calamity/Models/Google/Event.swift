//
//  Event.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/5/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Event: GoogleBaseModel {
    @objc var name = ""
    var type: EventType {
        get {
            return EventType(rawValue: parsedType?.intValue ?? UndefValue) ?? .nothing
        }
        set {
            parsedType = NSNumber(value: type.rawValue)
        }
    }
    
    @objc private var parsedType: NSNumber?
    
    var days: IndexSet = IndexSet()
    var abilities: [EventAbility] = []
    
    @objc var ifMana: Int = UndefValue
    @objc var ifKingRep: Int = UndefValue
    @objc var ifPeopleRep: Int = UndefValue
    @objc var ifCorrupt: Int = UndefValue
    
    var defaultDiePercent: CGFloat = 0
    @objc var eventDescription: String = ""
    
    @objc var dayString: String = "" {
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

    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id",
            "name" : "name",
            "parsedType" : "type",
            "dayString" : "day",
            "ifMana" : "if_mana",
            "ifKingRep" : "if_king_rep",
            "ifPeopleRep" : "if_people_rep",
            "ifCorrupt" : "if_corrupt",
            "eventDescription" : "description",
        ]
    }
    
    @objc static func jsonTransformer(forKey key: String!) -> ValueTransformer! {
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
