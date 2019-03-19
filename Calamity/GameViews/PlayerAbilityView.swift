//
//  PlayerAbilityView.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/20/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class PlayerAbilityView: UIView {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBarView!
    
    var ability: Ability? = nil {
        didSet {
            guard let ab = ability else { return }
            
            nameLabel.text = ab.abilityName
            
            progressBar.setProgress(CGFloat(ab.manaCost) / CGFloat(100))
            valueLabel.text = String(format: "%li", Int(ab.manaCost))
        }
    }
}
