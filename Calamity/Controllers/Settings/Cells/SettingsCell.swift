//
//  SettingsCell.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/28/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    var isLast: Bool = false {
        didSet {
            lineView.isHidden = isLast
        }
    }
    
    var image: UIImage? {
        didSet {
            iconImageView.image = image
        }
    }
    
    
}
