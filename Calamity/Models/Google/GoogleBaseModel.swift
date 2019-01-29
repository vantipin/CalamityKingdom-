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
    var identifier: String = "";
    
    class func withoutNil() -> Bool {
        return true
    }
    
    func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["identifier" : "id"]
    }
    
    func dictionaryValue() -> [AnyHashable : Any]! {
        if let keyPaths = self.jsonKeyPathsByPropertyKey() {
            return self.dictionaryWithValues(forKeys: (Array(keyPaths.keys) as! [String]))
        }
        
        return [:]
    }
}
