//
//  CityView.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/20/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class CityView: UIView {
    @IBOutlet weak var cityIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var currLiveLabel: UILabel!
    @IBOutlet weak var progressBar: ColourfulProgressView!
    
    private var animationCycle: Int = 0
    
    var city: City? = nil {
        didSet {
            guard let city = city else { return }
            
            configureShadow()
            
            nameLabel.text = city.name
            
            
            if descrLabel != nil {
                descrLabel.text = city.cityDescription
                currLiveLabel.isHidden = false
                currLiveLabel.text = String(format: "%li жителей (%li%% выживших)", city.currPeopleCount, Int(100.0 * CGFloat(city.currPeopleCount) / CGFloat(city.initPeopleCount)))
            } else {
                currLiveLabel.isHidden = true
            }
            
            let currValue = Int(100 - (100 * CGFloat(city.currPeopleCount) / CGFloat(city.initPeopleCount)))
            progressBar.update(toCurrentValue: currValue, animated: true)
            
            if nil == cityIconImageView.image {
                cityIconImageView.image = UIImage(named: city.type.imageName())
            }
            
            cityIconImageView.isHighlighted = city.currPeopleCount == 0
            
            let inDanger = city.cityInDanger
            
            if let view: UIView = viewWithTag(666) {
                view.isHidden = !inDanger
                view.alpha = 1
            }
            
            if let view = viewWithTag(6666) {
                view.alpha = 0.0
                view.isHidden = !inDanger
            }
            
            animationCycle += 1
            animateCityDander()
        }
    }
    
    func configureShadow() {
        cityIconImageView.layer.shadowColor = UIColor.white.cgColor
    }
    
    func stopAnimations() {
        guard let trashView = viewWithTag(6666) else { return }
        trashView.alpha = 0
        
        guard let secondView = viewWithTag(666) else { return }
        secondView.isHidden = true
    }
    
    func animateCityDander() {
        if nil == city || !city!.cityInDanger {
            stopAnimations()
            return
        }
        
        guard let trashView = viewWithTag(6666) else { return }
        
        let show: Bool = trashView.alpha == 0
        let animationCycle = self.animationCycle
        
        UIView.animate(withDuration: 0.5, animations: {
            trashView.alpha = show ? 1 : 0
        }) { [weak self] finished in
            guard let self = self else { return }
            
            if animationCycle == self.animationCycle {
                self.animateCityDander()
            }
        }
    }
}
