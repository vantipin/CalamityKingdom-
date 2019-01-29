//
//  GDBSheet.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/29/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import Mantle

class GDBSheet: MTLModel, MTLJSONSerializing {
    var name: String = ""
    var sheetUrl: String = ""
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "sheetUrl": "id.$t",
            "name": "title.$t"
        ]
    }
    
    var sheetId: String {
        return sheetUrl.components(separatedBy: "/").last ?? ""
    }
    
    var worksheetId: String {
        let components = sheetUrl.components(separatedBy: "/")
        
        if components.count >= 4 {
            return components[components.count - 4]
        }
        
        return ""
    }
}
