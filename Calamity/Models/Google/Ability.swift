//
//  Ability.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Ability: GoogleBaseModel {
    @objc var dangerId: String = ""
    var abilityType: AbilityType {
        get {
            guard let type = parsedType, let intType = Int(type), let ability = AbilityType(rawValue: intType) else {
                return .nobody
            }
            
            return ability
        }
        set {
            parsedType = "\(abilityType.rawValue)"
        }
    }
    
    @objc private var parsedType: String?
    
    private var designedAbilityName: String? = nil
    
    @objc var manaCost = 0 {
        didSet {
            let computed = min(max(manaCost, Variable.minValue), Variable.maxValue)
            
            if manaCost != computed {
                manaCost = computed
            }
        }
    }
    
    @objc var kingRepCost = 0 {
        didSet {
            let computed = min(max(kingRepCost, Variable.minValue), Variable.maxValue)
            
            if kingRepCost != computed {
                kingRepCost = computed
            }
        }
    }
    
    @objc var peopleRepCost = 0 {
        didSet {
            let computed = min(max(peopleRepCost, Variable.minValue), Variable.maxValue)
            
            if peopleRepCost != computed {
                peopleRepCost = computed
            }
        }
    }
    
    @objc var corruptCost = 0 {
        didSet {
            let computed = min(max(corruptCost, Variable.minValue), Variable.maxValue)
            
            if corruptCost != computed {
                corruptCost = computed
            }
        }
    }
    
    
    var damage: CGFloat = 0
    @objc private var parsedDamage: String? {
        didSet {
            guard let parsed = parsedDamage, let formatter = NumberFormatter().number(from: parsed) else { return }
            damage = CGFloat(truncating: formatter)
        }
    }
    
    @objc var timeToDestroyDanger = 0
    @objc private var parsedTimeToDestroy: String? {
        didSet {
            guard let parsed = parsedTimeToDestroy, let intValue = Int(parsed) else { return }
            timeToDestroyDanger = intValue
        }
    }
    
    @objc var abilityDescription = ""
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return  [
            "dangerId" : "id_disaster",
            "identifier" : "id_reply",
            "abilityName" : "text",
            "abilityDescription": "result",
            "parsedType": "type",
            "manaCost": "mana",
            "kingRepCost": "king_rep",
            "peopleRepCost": "people_rep",
            "corruptCost": "corrupt",
            "parsedTimeToDestroy": "time",
            "parsedDamage": "damage"
        ]
    }
    
    @objc var abilityName: String? {
        get {
            guard nil == designedAbilityName else {
                return designedAbilityName
            }
            
            guard let constants = Game.instance.gameConstants else { return "" }
            
            switch self.abilityType {
            case .appeal:
                return constants.ability_appeal?.name ?? ""
            case .hypnosis:
                return constants.ability_hypnosis?.name ?? ""
            case .chaos:
                return constants.ability_chaos?.name ?? ""
            case .telekinesis:
                return constants.ability_telekinesis?.name ?? ""
            case .nobody:
                return ""
            }
        }
        set {
            designedAbilityName = abilityName
        }
    }
    
    @objc static func jsonTransformer(forKey key: String!) -> ValueTransformer! {
        let keysToTransform = ["manaCost",
                               "kingRepCost",
                               "peopleRepCost",
                               "corruptCost"]
        
        if keysToTransform.contains(key) {
            return Ability.intTransformer()
        }
        
        return ValueTransformer()
    }
    
    func abilityActionString() -> String {
        guard let constants = Game.instance.gameConstants else { return "" }
        
        switch self.abilityType {
        case .appeal:
            return constants.ability_appeal_action?.name ?? ""
        case .hypnosis:
            return constants.ability_hypnosis_action?.name ?? ""
        case .chaos:
            return constants.ability_chaos_action?.name ?? ""
        case .telekinesis:
            return constants.ability_telekinesis_action?.name ?? ""
        case .nobody:
            return ""
        }
    }
}
