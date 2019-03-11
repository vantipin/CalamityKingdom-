//
//  GameConstant.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class GameConstant {
    var ability_hypnosis_action: Constant? = nil
    var ability_chaos_action: Constant? = nil
    var ability_telekinesis_action: Constant? = nil
    var ability_appeal_action: Constant? = nil
    var danger_type_disaster: Constant? = nil
    var danger_type_monsters: Constant? = nil
    var danger_type_plague: Constant? = nil
    var danger_type_curse: Constant? = nil
    var ability_appeal: Constant? = nil
    var ability_hypnosis: Constant? = nil
    var ability_chaos: Constant? = nil
    var ability_telekinesis: Constant? = nil
    var corrupt: Constant? = nil
    var mana: Constant? = nil
    var king_rep: Constant? = nil
    var people_rep: Constant? = nil
    var mana_regen: Constant? = nil
    var mana_to_king_rep: Constant? = nil
    var mana_to_corrupt: Constant? = nil
    var mana_to_people_rep: Constant? = nil
    var days_count: Constant? = nil
    
    class func keyPath(fromId id: String) -> ReferenceWritableKeyPath<GameConstant, Constant?> {
        switch id {
        case "ability_hypnosis_action":
            return \GameConstant.ability_hypnosis_action
        case "ability_chaos_action":
            return \GameConstant.ability_chaos_action
        case "ability_telekinesis_action":
            return \GameConstant.ability_telekinesis_action
        case "ability_appeal_action":
            return \GameConstant.ability_appeal_action
        case "danger_type_disaster":
            return \GameConstant.danger_type_disaster
        case "danger_type_monsters":
            return \GameConstant.danger_type_monsters
        case "danger_type_plague":
            return \GameConstant.danger_type_plague
        case "danger_type_curse":
            return \GameConstant.danger_type_curse
        case "ability_appeal":
            return \GameConstant.ability_appeal
        case "ability_hypnosis":
            return \GameConstant.ability_hypnosis
        case "ability_chaos":
            return \GameConstant.ability_chaos
        case "ability_telekinesis":
            return \GameConstant.ability_telekinesis
        case "corrupt":
            return \GameConstant.corrupt
        case "mana":
            return \GameConstant.mana
        case "king_rep":
            return \GameConstant.king_rep
        case "people_rep":
            return \GameConstant.people_rep
        case "mana_regen":
            return \GameConstant.mana_regen
        case "mana_to_king_rep":
            return \GameConstant.mana_to_king_rep
        case "mana_to_corrupt":
            return \GameConstant.mana_to_corrupt
        case "mana_to_people_rep":
            return \GameConstant.mana_to_people_rep
        case "days_count":
            return \GameConstant.days_count
        default:
            return \GameConstant.ability_hypnosis_action
        }
    }
}
