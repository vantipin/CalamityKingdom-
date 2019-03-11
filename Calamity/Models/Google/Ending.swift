//
//  Ending.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/5/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class Ending: GoogleBaseModel {
    @objc var text = ""
    @objc var imageName = ""
    @objc var endingSound = ""
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier" : "ending_id",
            "text": "text",
            "imageName": "image_name",
            "endingSound" : "ending_sound",
        ]
    }
}
