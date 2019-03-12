//
//  SmartJSONAdapter.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/12/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import Mantle

protocol SmartJSONAdapting: MTLJSONSerializing {
    static func withoutNil() -> Bool
}

class SmartJSONAdapter: MTLJSONAdapter {
    func serializable(propertyKeys: Set<String>, forModel model: GoogleBaseModel) -> Set<String> {
        guard type(of: model).withoutNil() else {
            return propertyKeys
        }
        
        return propertyKeys.filter { (key) -> Bool in
            guard let value = model.dictionaryValue[key] else { return false }
            return !(value is NSNull)
        }
    }
}
