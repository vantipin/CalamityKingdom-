//
//  GDBModel.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/29/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import Mantle

class GDBModel: MTLModel, MTLJSONSerializing {
    static var googleDocsDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "M/d/yyyy"
        
        return formatter
    }
    
    class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [:]
    }

    @objc class func googleDocsDateJSONTransformer() -> ValueTransformer {
        return MTLValueTransformer(usingForwardBlock: { (value, _, _) -> Any? in
            return self.googleDocsDateFormatter.date(from: value as? String ?? "")
        }, reverse: { (value, _, _) -> Any? in
            return self.googleDocsDateFormatter.string(from: value as? Date ?? Date())
        })
    }
    
    @objc class func intTransformer() -> ValueTransformer {
        return MTLValueTransformer(usingForwardBlock: { (value, _, _) -> Any? in
            return Int(value as? String ?? "") ?? 0
        }, reverse: { (value, _, _) -> Any? in
            return "\(value as? Int ?? 0)"
        })
    }
}

