//
//  GoogleDocsServiceLayer.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/29/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit
import Mantle

typealias GoogleDocsServiceLayerCompletionBlock = (_ objects: [MTLModel]?, _ error: Error?) -> Void

class GoogleDocsServiceLayer {
    static var cellRegex: NSRegularExpression {
        return try! NSRegularExpression(pattern: "^(\\D{1,})(\\d{1,})$", options: .useUnicodeWordBoundaries)
    }
    
    class func sheets(worksheetKey key: String, completion: @escaping GoogleDocsServiceLayerCompletionBlock) {
        GoogleDocsSpreadsheetAPIClient.shared.sheets(spreadSheetKey: key) { (success, result, error) in
            if success,
                let result = result,
                let feed = result["feed"] as? [AnyHashable : Any],
                let entries = feed["entry"] as? [[AnyHashable : Any]] {
                var objects: [GDBSheet] = []
                
                entries.forEach({ (entry) in
                    do {
                        let obj = try MTLJSONAdapter.model(of: GDBSheet.self, fromJSONDictionary: entry)
                        objects.append(obj as! GDBSheet)
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
    
    class func objects(worksheetKey key: String, sheetId gid: String, completion: @escaping GoogleDocsServiceLayerCompletionBlock) {
        self.objects(worksheetKey: key, sheetId: gid, modelClass: GDBModel.self, completion: completion)
    }
    
    class func objects(worksheetKey key: String, sheetId gid: String, modelClass: AnyClass, completion: @escaping GoogleDocsServiceLayerCompletionBlock) {
        GoogleDocsSpreadsheetAPIClient.shared.cells(spreadSheetKey: key, sheetId: gid) { (success, result, error) in
            if success,
                let result = result,
                let feed = result["feed"] as? [AnyHashable : Any],
                var entries = feed["entry"] as? [[AnyHashable : Any]],
                entries.count > 0 {
                
                var objects: [GDBModel] = []
                var keys: [String : String] = [:]
                var index = 0
                var entry = entries[index]
                
                var cellNumber: String = (entry["title"] as! [AnyHashable : String])["$t"]!
                var row = self.row(cellTitle: cellNumber)
                
                while row == 1 {
                    keys[self.column(cellTitle: cellNumber)] = (entry["content"] as! [AnyHashable : String])["$t"]!
                    index += 1
                    entry = entries[index]
                    cellNumber = (entry["title"] as! [AnyHashable : String])["$t"]!
                    row = self.row(cellTitle: cellNumber)
                }
                
                entries = Array(entries.dropFirst(keys.count))
                
                var nextObject: [AnyHashable : Any] = [:]
                var nextRow = 2
                
                entries.forEach({ (entry) in
                    cellNumber = (entry["title"] as! [AnyHashable : String])["$t"]!
                    nextRow = self.row(cellTitle: cellNumber)
                    
                    if nextRow != row {
                        do {
                            let obj = try MTLJSONAdapter.model(of: modelClass, fromJSONDictionary: nextObject)
                            objects.append(obj as! GDBModel)
                        } catch {
                            print("Error = \(error)")
                        }
                        
                        row = nextRow
                        nextObject = [:]
                    }
                    
                    if let key = keys[self.column(cellTitle: cellNumber)] {
                        let value: String = (entry["content"] as! [AnyHashable : String])["$t"]!
                        nextObject[key] = value
                    }
                })
                
                do {
                    let obj = try MTLJSONAdapter.model(of: modelClass, fromJSONDictionary: nextObject)
                    objects.append(obj as! GDBModel)
                } catch {
                    print("Error = \(error)")
                }
                
                completion(objects, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Cell regex stuff
    
    private class func matches(cellTitle: String) -> [NSTextCheckingResult] {
        return self.cellRegex.matches(in: cellTitle, options: .reportCompletion, range: NSRange(location: 0, length: cellTitle.count))
    }
    
    private class func row(cellTitle: String) -> Int {
        guard let rowMatch = self.matches(cellTitle: cellTitle).first else { return 0 }
        
        let rowRange = rowMatch.range(at: 2)
        return Int((cellTitle as NSString).substring(with: rowRange)) ?? 0
    }
    
    private class func column(cellTitle: String) -> String {
        guard let columnMatch = self.matches(cellTitle: cellTitle).first else { return "" }
        
        let columnRange = columnMatch.range(at: 1)
        return (cellTitle as NSString).substring(with: columnRange)
    }
    
}
