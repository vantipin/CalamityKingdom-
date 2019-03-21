//
//  LandingController.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/25/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class LandingController: BaseController {
    var wasUpdated = false
    @IBOutlet var controlButtons: [UIButton]!
    @IBOutlet weak var progressBar: ProgressBarView!
    
    var withUpdate: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar.setProgress(0)
        
        if withUpdate {
            controlButtons.forEach { (button) in
                button.alpha = 0
            }
        }
        
        progressBar.alpha = 0
    }
    
    class func show(withUpdate: Bool = true) {
        if let controller = R.storyboard.main.ppLandingControllerID(),
            let window = UIApplication.shared.keyWindow,
            let root = window.rootViewController {
            
            Settings.shared.isMusicOn = Settings.shared.isMusicOn
            controller.withUpdate = withUpdate
            
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !wasUpdated, withUpdate else { return }
    
        wasUpdated = true
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            self.progressBar.alpha = 1
        }
        
        Game.instance.parseGame(withUpdate: true, progress: { [weak self] (progress) in
            self?.progressBar.setProgress(progress, animated: true)
        }) { (success, error) in
            print("Parsed - \(success), error = \(error?.localizedDescription ?? "No error")")
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                
                self.controlButtons.forEach { (button) in
                    button.alpha = 1
                }
                
                self.progressBar.alpha = 0
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func startPressed(_ sender: Any) {
        BaseGameController.show()
    }

    @IBAction func settingsPressed(_ sender: Any) {
        if let controller = SettingsController.controller() {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func creditsPressed(_ sender: Any) {
        
    }
}
