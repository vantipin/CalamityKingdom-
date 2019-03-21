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
    @IBOutlet weak var updateLoader: UIActivityIndicatorView!
    
    @IBOutlet var fieldControls: [UIView]!
    @IBOutlet var cityViews: [CityView]!
    @IBOutlet var playerAbilities: [PlayerAbilityView]!
    
    var wasTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNotifications()
        
        for city in cityViews {
            let tap = UITapGestureRecognizer(target: self, action: #selector(cityPressed(tap:)))
            city.addGestureRecognizer(tap)
        }
        
        redrawInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard !skipUpdates else { return }
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
    
    func configurePlayerAbilities() {
        for view in playerAbilities {
            guard let playerAbility = PlayerAbility(rawValue: view.tag) else { return }
            view.ability = playerAbility
        }
    }
    
    func configureCities() {
        let cities = Game.instance.cities
        
        for cityView in cityViews {
            guard cityView.tag < cities.count else { continue }
            
            let city = cities[cityView.tag]
            cityView.city = city
        }
    }
    
    func configureTime() {
        timeLabel.text = "День: \(Game.instance.daysCount)"
    }
    
    func redrawInterface() {
        configureCities()
        configurePlayerAbilities()
        configureTime()
    }
    
    func checkAndRedraw() {
        var dangersInProgress: [Danger] = []
        let dangersToApply = Game.instance.dangersToApply
        
        if dangersToApply.count > 0 {
            for danger in dangersToApply {
                if let city = danger.predefinedCity {
                    if let cityDanger = city.currentDanger {
                        if !cityDanger.inProgress {
                            danger.timeToAppear += Int(1 + arc4random() % 3)
                        }
                    } else {
                        city.currentDanger = danger
                        danger.affectedCity = city
                        danger.inProgress =  true
                        danger.predefinedCity = nil
                        dangersInProgress.append(danger)
                    }
                } else {
                    let freeCities = Game.instance.freeCities
                    
                    if freeCities.count > 0 {
                        let randomIndex = Int(arc4random()) % freeCities.count
                        let affectedCity = freeCities[randomIndex]
                        affectedCity.currentDanger = danger
                        danger.affectedCity = affectedCity
                        danger.inProgress =  true
                        danger.predefinedCity = nil
                        dangersInProgress.append(danger)
                    }
                }
            }
        }
        
        // FIRE
        let firedDangers = Game.instance.firedDangers
        
        if firedDangers.count > 0 {
            for danger in firedDangers {
                guard let affectedCity = danger.affectedCity else { continue }
                
                _ = affectedCity.recalculateCurrentRating(withDanger: danger)
                danger.removed = true
                affectedCity.currentDanger = nil
            }
        }
        
        for danger in dangersInProgress {
            danger.inProgress = false
        }
        
        dangersInProgress.removeAll()
        
        var hasPeople = false
        
        for city in Game.instance.cities {
            if city.currPeopleCount > 0 {
                hasPeople = true
                break
            }
        }
        
        if hasPeople {
            redrawInterface()
            checkEvents()
        } else {
            EndingsViewController.show(withId: GameEnding.defeat.rawValue)
        }
    }
    
    func checkEvents() {
        if let event = Game.instance.currDayEvent, !wasTapped {
            // TODO - Show event controler here
        }
    }
    
    func timerTick() {
        Game.instance.daysCount += 1
        
        if Game.instance.leftTimeHours <= 0 {
            EndingsViewController.show(withId: GameEnding.won.rawValue)
        } else {
            Game.instance.player.mana += Game.instance.gameConstants?.mana_regen?.constValue ?? 0
            
            checkAndRedraw()
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func parseGame() {
        updateLoader.startAnimating()
        
        UIView.animate(withDuration: 0.3) {
            for view in self.fieldControls {
                view.alpha = 0
            }
        }
        
        delay(0.01) {
            Game.instance.parseGame(withUpdate: true, progress: nil, completion: { [weak self] (completed, error) in
                guard let self = self else { return }
                
                self.updateLoader.stopAnimating()
                
                self.checkAndRedraw()
                
                UIView.animate(withDuration: 0.3) {
                    for view in self.fieldControls {
                        view.alpha = 1
                    }
                }
            })
        }
    }

    // MARK: - Actions
    
    @IBAction func magePressed(_ sender: Any) {
        guard !wasTapped else { return }
        
        if let controller = SettingsController.controller(withExit: true) {
            wasTapped = true
            
            self.present(controller, animated: true, completion: { [weak self] in
                self?.wasTapped = false
            })
        }
    }
    
    @objc func cityPressed(tap: UITapGestureRecognizer) {
        guard let cityView = tap.view as? CityView, !wasTapped else { return }
        let cities = Game.instance.cities
        let city = cities[cityView.tag]
        
        if city.cityInDanger {
            // Show danger popup
        } else {
            // Show info popup
        }
    }
    
    // For test purposes only
    @IBAction func updatePressed(_ sender: Any) {
        guard !wasTapped else { return }
    }
    
    @IBAction func libraryPressed(_ sender: Any) {
        guard !wasTapped else { return }
    }
    
    @IBAction func sleepPressed(_ sender: Any) {
        guard !wasTapped else { return }
        
        timerTick()
    }
}

extension BaseGameController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fieldContentView
    }
}

// Game Notifications
extension BaseGameController {
    func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearDanger(notification:)), name: GameNotificationName.clearDanger.notificationName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearUI(notification:)), name: GameNotificationName.clearUI.notificationName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearEvent(notification:)), name: GameNotificationName.clearEvent.notificationName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI(notification:)), name: GameNotificationName.updateUI.notificationName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sleepEvent(notification:)), name: GameNotificationName.timerTick.notificationName(), object: nil)
    }
    
    @objc func updateUI(notification: Notification) {
        redrawInterface()
    }
    
    @objc func clearUI(notification: Notification) {
        
    }
    
    @objc func clearDanger(notification: Notification) {
        
    }
    
    @objc func clearEvent(notification: Notification) {
        
    }
    
    @objc func sleepEvent(notification: Notification) {
        
    }
}
