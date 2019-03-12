//
//  GoogleBaseModel.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/25/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit
import Mantle

class GoogleBaseModel: GDBModel {
    @objc var identifier: String = "";
    
    
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["identifier" : "id"]
    }
    
    func dictionaryValue() -> [AnyHashable : Any]! {
        if let keyPaths = type(of: self).jsonKeyPathsByPropertyKey() {
            return self.dictionaryWithValues(forKeys: (Array(keyPaths.keys) as! [String]))
        }
        
        return [:]
    }
    
    @objc class func zeroTransformer() -> ValueTransformer {
        return MTLValueTransformer(usingForwardBlock: { (value, _, _) -> Any? in
            guard let str = value as? String, str.count > 0 else { return NSNumber(value: UndefValue) }
            return NSNumber(value: Int(str) ?? UndefValue)
        }, reverse: { (value, _, _) -> Any? in
            guard let eventValue = value as? NSNumber else { return "" }
            return eventValue.intValue != UndefValue ? "\(eventValue)" : ""
        })
    }
}

extension GoogleBaseModel: SmartJSONAdapting {
    static func withoutNil() -> Bool {
        return true
    }
}
