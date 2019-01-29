//
//  DispatchQueue+Helper.swift
//  Calamity
//
//  Created by Pavel Stoma on 12/30/18.
//  Copyright © 2018 Pavel Stoma. All rights reserved.
//

import UIKit

public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file,
                           function: String = #function,
                           line: Int = #line,
                           block: () -> Void) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String,
                           block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        guard !_onceTracker.contains(token) else { return }
        
        _onceTracker.append(token)
        block()
    }
    
    /**
     Executes a block of code after specified delay.
     
     - parameter delay: A delay for execution in seconds
     - parameter block: Block to execute once
     */
    public class func delay(_ delay:Double, block:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: block)
    }
}
