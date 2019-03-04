//
//  Danger.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Danger: GoogleBaseModel {
    var name = ""
    var dangerDescription = ""
    
    var dangerType: DangerType = .curse
    
    var result: DangerResult = DangerResult()
    var abilitiesToRemove: [Ability] = []
    
    var timeToAppear: Int = 0
    var affectedCity: City? = nil
    
    var removed: Bool = false
    var inProgress: Bool = false
    
    var predefinedCity: City? = nil
    var predefinedTime: Int = 0
    
    override func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id_disaster",
            "defaultDieCoef" : "default_die",
            "name": "name",
            "dangerDescription": "description",
            "dangerType": "type",
            "timeToAppear": "day",
        ]
    }
    
    var dangelTypeName: String {
        return dangerType.name()
    }
    
    var dangerTypeIcon: UIImage {
        return dangerType.iconImage()
    }
    
    func appendAbility(ability: Ability) {
        abilitiesToRemove.append(ability)
    }
}
