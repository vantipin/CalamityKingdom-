//
//  Archimage.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/4/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Archimage: GoogleBaseModel {
    var name: String = ""
    var popularity: Int = 0
    
    override func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return  [
            "identifier" : "id",
            "name": "name",
            "popularity": "popularity",
        ]
    }
}
