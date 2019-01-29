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
    
    var manaCost = 0
    
    var kingRepCost = 0
    var peopleRepCost = 0
    var corruptCost = 0
    
    var damage: CGFloat = 0
    var timeToDestroyDanger = 0
    
    var abilityName = ""
    var abilityDescription = ""
    
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
