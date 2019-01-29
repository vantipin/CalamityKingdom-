//
//  DangerResult.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class DangerResult {
    var helpAbilityType: AbilityType = .nobody
    var peopleCountToDie: [CGFloat] = []
    var defaultDieCoef: CGFloat = 0
    
    private var diedPeople: CGFloat = CGFloat(UndefValue)
    
    func peopleCountToDieWithType() -> CGFloat {
        if diedPeople >= 0 {
            return diedPeople
        }
        
        if helpAbilityType == .nobody {
            diedPeople = defaultDieCoef
            return diedPeople
        }
        
        if helpAbilityType.rawValue < peopleCountToDie.count {
            diedPeople = peopleCountToDie[helpAbilityType.rawValue]
        }
        
        return diedPeople
    }
}
