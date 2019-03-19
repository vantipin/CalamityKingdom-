//
//  BaseGameController.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/25/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class BaseGameController: BaseController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fieldContentView: UIView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet var fieldControls: [UIView]!
    @IBOutlet var cityViews: [UIView]!
    @IBOutlet var playerAbilities: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard !skipUpdates else { return }
        
        
    }
    
    class func show() {
        
    }
    

    // MARK: - Actions
    
    @IBAction func magePressed(_ sender: Any) {
        
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        
    }
    
    @IBAction func libraryPressed(_ sender: Any) {
        
    }
    
    @IBAction func sleepPressed(_ sender: Any) {
        
    }

}
