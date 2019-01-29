//
//  Constant.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Constant: GoogleBaseModel {
    var name: String = ""
    var constDescription: String = ""
    var constValue: Int = 0
    
    override func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return  [
            "identifier" : "id",
            "name": "name",
            "constDescription": "description",
            "constValue": "value"
        ]
    }
}
