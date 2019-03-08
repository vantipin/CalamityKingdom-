//
//  LibraryItem.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/8/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class LibraryItem: GoogleBaseModel {
    var itemName = ""
    var day: Int = 0
    var itemDescription = ""
    
    override func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id",
            "itemName": "name",
            "itemDescription": "text",
            "day": "day"
        ]
    }
}
