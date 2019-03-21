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
    @IBOutlet var playerAbilities: [PlayerAbilityView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for view in playerAbilities {
            guard let playerAbility = PlayerAbility(rawValue: view.tag) else { return }
            view.ability = playerAbility
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard !skipUpdates else { return }
        
        parseGame(withUpdateAndAnimation: false)
    }
    
    class func show() {
        if let controller = R.storyboard.main.baseGameControllerID(),
            let window = UIApplication.shared.keyWindow,
            let root = window.rootViewController {
            
            UIView.transition(from: root.view,
                              to: controller.view,
                              duration: 0.65,
                              options: .transitionCrossDissolve) { (finished) in
                                controller.skipUpdates = true
                                window.rootViewController = controller
                                controller.skipUpdates = false
            }
        }
    }
    
    func parseGame(withUpdateAndAnimation animated: Bool) {
        
    }

    // MARK: - Actions
    
    @IBAction func magePressed(_ sender: Any) {
        if let controller = SettingsController.controller(withExit: true) {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // For test purposes only
    @IBAction func updatePressed(_ sender: Any) {
        
    }
    
    @IBAction func libraryPressed(_ sender: Any) {
        
    }
    
    @IBAction func sleepPressed(_ sender: Any) {
        
    }

}

extension BaseGameController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fieldContentView
    }
}
