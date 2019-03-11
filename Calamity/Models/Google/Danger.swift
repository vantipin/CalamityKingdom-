//
//  Danger.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Danger: GoogleBaseModel {
    @objc var name = ""
    @objc var dangerDescription = ""
    
    @objc var defaultDieCoef: CGFloat = CGFloat(UndefValue)
    
    var dangerType: DangerType {
        get {
            return DangerType(rawValue: parsedType?.intValue ?? UndefValue) ?? .disaster
        }
        set {
            parsedType = NSNumber(value: dangerType.rawValue)
        }
    }
    
    @objc private var parsedType: NSNumber?
    
    
    var result: DangerResult = DangerResult()
    var abilitiesToRemove: [Ability] = []
    
    @objc var timeToAppear: Int = 0
    var affectedCity: City? = nil
    
    var removed: Bool = false
    var inProgress: Bool = false
    
    var predefinedCity: City? = nil
    var predefinedTime: Int = 0
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id_disaster",
            "defaultDieCoef" : "default_die",
            "name": "name",
            "dangerDescription": "description",
            "parsedType": "type",
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
