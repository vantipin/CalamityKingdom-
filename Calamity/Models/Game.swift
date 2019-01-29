//
//  Game.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/30/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

typealias GameCallback = (_ success: Bool, _ error: Error?) -> Void
typealias ProgressCallback = (_ progress: CGFloat) -> Void

class Game: NSObject {
    static let instance = Game()
    
    var gameConstants: GameConstant? = nil
    var player: Player = Player()
}
