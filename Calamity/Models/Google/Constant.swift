//
//  Constant.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Constant: GoogleBaseModel {
    @objc var name: String = ""
    @objc var constDescription: String = ""
    @objc var parsedConstValue: NSNumber?
    
    var constValue: Int {
        get {
            return parsedConstValue?.intValue ?? UndefValue
        }
        set {
            parsedConstValue = NSNumber(value: constValue)
        }
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return  [
            "identifier" : "id",
            "name": "name",
            "constDescription": "description",
            "parsedConstValue": "value"
        ]
    }
    
    @objc static func jsonTransformer(forKey key: String!) -> ValueTransformer! {
        let keysToTransform = ["value"]
        
        if keysToTransform.contains(key) {
            return Constant.zeroTransformer()
        }
        
        return ValueTransformer()
    }
    
}
