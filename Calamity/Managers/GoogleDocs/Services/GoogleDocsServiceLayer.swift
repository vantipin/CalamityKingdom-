//
//  GoogleDocsServiceLayer.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/29/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit
import Mantle

typealias GoogleDocsServiceLayerCompletionBlock = (_ objects:[MTLModel]?, _ error: Error?) -> Void

class GoogleDocsServiceLayer {
    class func sheets(worksheetKey key: String, completion: @escaping GoogleDocsServiceLayerCompletionBlock) {
        GoogleDocsSpreadsheetAPIClient.shared.sheets(spreadSheetKey: key) { (success, result, error) in
            if success, let result = result, let feed = result["feed"] as? [AnyHashable : Any], let entries = feed["entry"] as? [[AnyHashable : Any]] {
                var objects: [GDBSheet] = []
                
                entries.forEach({ (entry) in
                    do {
                        let obj: GDBSheet = try MTLJSONAdapter.model(of: GDBSheet.self, fromJSONDictionary: entry) as! GDBSheet
                        objects.append(obj)
                    } catch {
                        print("Error = \(error)")
                    }
                })
                
                completion(objects, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
}
