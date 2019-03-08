//
//  GoogleTable.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/8/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class GoogleTable: GDBSheet {
    var sheet: Sheet
    
    init(table: Sheet, url: String) {
        sheet = table
        
        super.init()
        
        sheetUrl = url
    }
    
    required init!(coder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(dictionary dictionaryValue: [AnyHashable : Any]!) throws {
        fatalError("init(dictionary:) has not been implemented")
    }
}
