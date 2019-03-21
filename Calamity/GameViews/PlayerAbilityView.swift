//
//  PlayerAbilityView.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/20/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

enum PlayerAbility: Int {
    case mana
    case kingRep
    case peopleRep
    case currupt
    
    func name() -> String {
        guard let constants = Game.instance.gameConstants else { return "" }
        
        switch self {
        case .mana:
            return constants.mana?.name ?? ""
        case .kingRep:
            return constants.king_rep?.name ?? ""
        case .peopleRep:
            return constants.people_rep?.name ?? ""
        case .currupt:
            return constants.corrupt?.name ?? ""
        }
    }
    
    func value() -> CGFloat {
        let player = Game.instance.player
        
        switch self {
        case .mana:
            return CGFloat(player.mana) / CGFloat(100)
        case .kingRep:
            return CGFloat(player.kingRep) / CGFloat(100)
        case .peopleRep:
            return CGFloat(player.peopleRep) / CGFloat(100)
        case .currupt:
            return CGFloat(player.corrupt) / CGFloat(100)
        }
    }
}

class PlayerAbilityView: UIView {
    @IBOutlet weak var progressBar: ProgressBarView!
    
    var ability: PlayerAbility = .mana {
        didSet {
            progressBar.setProgress(ability.value())
            progressBar.name = ability.name()
            progressBar.value = "100"
        }
    }
}
