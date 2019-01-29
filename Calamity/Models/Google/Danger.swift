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
    
    
}
