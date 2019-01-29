//
//  GoogleDocsSpreadsheetAPIClient.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/29/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit
import Alamofire

typealias GoogleDocsAPICompletionBlock = (_ success: Bool, _ result: [AnyHashable : Any]?, _ error: Error?) -> Void

class GoogleDocsSpreadsheetAPIClient {
    let baseUrl = "https://spreadsheets.google.com/"
    
    static let shared = GoogleDocsSpreadsheetAPIClient()
    
    func cells(spreadSheetKey key: String, sheetId gid: String, completion: @escaping GoogleDocsAPICompletionBlock) {
        Alamofire.request(baseUrl + "feeds/cells/\(key)/\(gid)/public/basic?alt=json").validate().responseJSON { response in
            switch response.result {
            case .success:
                completion(true, response.result.value as? [AnyHashable: Any], nil)
            case .failure(let error):
                completion(false, nil, error)
            }
        }
    }
    
    func sheets(spreadSheetKey key: String, completion: @escaping GoogleDocsAPICompletionBlock) {
        Alamofire.request(baseUrl + "feeds/worksheets/\(key)/public/basic?alt=json").validate().responseJSON { response in
            switch response.result {
            case .success:
                completion(true, response.result.value as? [AnyHashable: Any], nil)
            case .failure(let error):
                completion(false, nil, error)
            }
        }
    }
}
