//
//  Ability.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Ability: GoogleBaseModel {
    var dangerId: String = ""
    var abilityType: AbilityType = .nobody
    
    private var designedAbilityName: String? = nil
    
    var manaCost = 0 {
        didSet {
            let computed = min(max(manaCost, Variable.minValue), Variable.maxValue)
            
            if manaCost != computed {
                manaCost = computed
            }
        }
    }
    
    var kingRepCost = 0 {
        didSet {
            let computed = min(max(kingRepCost, Variable.minValue), Variable.maxValue)
            
            if kingRepCost != computed {
                kingRepCost = computed
            }
        }
    }
    
    var peopleRepCost = 0 {
        didSet {
            let computed = min(max(peopleRepCost, Variable.minValue), Variable.maxValue)
            
            if peopleRepCost != computed {
                peopleRepCost = computed
            }
        }
    }
    
    var corruptCost = 0 {
        didSet {
            let computed = min(max(corruptCost, Variable.minValue), Variable.maxValue)
            
            if corruptCost != computed {
                corruptCost = computed
            }
        }
    }
    
    var damage: CGFloat = 0
    var timeToDestroyDanger = 0
    
    var abilityDescription = ""
    
    override func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return  [
            "dangerId" : "id_disaster",
            "identifier" : "id_reply",
            "abilityName" : "text",
            "abilityDescription": "result",
            "abilityType": "type",
            "manaCost": "mana",
            "kingRepCost": "king_rep",
            "peopleRepCost": "people_rep",
            "corruptCost": "corrupt",
            "timeToDestroyDanger": "time",
            "damage": "damage"
        ]
    }
    
    var abilityName: String? {
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
