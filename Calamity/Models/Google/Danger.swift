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
    
    var defaultDieCoef: CGFloat = CGFloat(UndefValue)
    @objc private var parsedDieCoef: String? {
        didSet {
            guard let parsedDie = parsedDieCoef, let formatter = NumberFormatter().number(from: parsedDie) else {
                defaultDieCoef = CGFloat(UndefValue)
                return
            }
            
            defaultDieCoef = CGFloat(truncating: formatter)
        }
    }
    
    var dangerType: DangerType {
        get {
            guard let parsedValue = parsedType else { return .disaster }
            return DangerType(rawValue: Int(parsedValue) ?? UndefValue) ?? .disaster
        }
        set {
            parsedType = "\(dangerType.rawValue)"
        }
    }
    
    @objc private var parsedType: String?

    var result: DangerResult = DangerResult()
    var abilitiesToRemove: [Ability] = []
    
    var timeToAppear: Int = 0
    @objc private var parsedAppearTime: String? {
        didSet {
            guard let appearTime = parsedAppearTime, let time = Int(appearTime) else {
                timeToAppear = 0
                return
            }
            
            timeToAppear = time
        }
    }
    
    var affectedCity: City? = nil
    
    var removed: Bool = false
    var inProgress: Bool = false
    
    var predefinedCity: City? = nil
    var predefinedTime: Int = 0
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id_disaster",
            "parsedDieCoef" : "default_die",
            "name": "name",
            "dangerDescription": "description",
            "parsedType": "type",
            "parsedAppearTime": "day",
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
