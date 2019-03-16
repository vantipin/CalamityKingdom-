//
//  LibraryItem.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/8/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class LibraryItem: GoogleBaseModel {
    @objc var itemName = ""
    @objc var day: Int = 0
    @objc var itemDescription = ""
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "id",
            "itemName": "name",
            "itemDescription": "text",
            "day": "day"
        ]
    }
    
    @objc static func jsonTransformer(forKey key: String!) -> ValueTransformer! {
        let keysToTransform = ["day"]
        
        if keysToTransform.contains(key) {
            return LibraryItem.intTransformer()
        }
        
        return ValueTransformer()
    }
}
