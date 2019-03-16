//
//  Archimage.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/4/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Archimage: GoogleBaseModel {
    @objc var name: String = ""
    @objc var popularity: Int = 0
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return  [
            "identifier" : "id",
            "name": "name",
            "popularity": "popularity",
        ]
    }
    
    @objc static func jsonTransformer(forKey key: String!) -> ValueTransformer! {
        let keysToTransform = ["popularity"]
        
        if keysToTransform.contains(key) {
            return Archimage.intTransformer()
        }
        
        return ValueTransformer()
    }
}
