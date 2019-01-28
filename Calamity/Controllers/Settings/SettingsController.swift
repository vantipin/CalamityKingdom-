//
//  SettingsController.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/28/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class SettingsController: BaseController {
    enum Setting: Int {
        case music
        case sound
    }
    
    
    @IBOutlet weak var itemsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchAction(sender: UISwitch) {
        guard let option = Setting(rawValue: sender.tag) else { return }
        
        switch option {
        case .music:
            Settings.shared.isSoundsOn = sender.isOn
        case .sound:
            Settings.shared.isSoundsOn = sender.isOn
        }
    }
}

extension SettingsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func titleAtOption(option: Setting) -> String {
        switch option {
        case .music:
            return "Music"
        case .sound:
            return "Sound"
        }
    }
    
    func iconImageAtOption(option: Setting) -> UIImage? {
        switch option {
        case .music:
            return R.image.musicIcon()
        case .sound:
            return R.image.soundIcon()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SettingsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCellID", for: indexPath) as! SettingsCell
        
        guard let option = Setting(rawValue: indexPath.row) else {
            return cell
        }
        
        cell.titleLabel.text = self.titleAtOption(option: option)
        cell.iconImageView.image = self.iconImageAtOption(option: option)
        cell.switchControl.tag = indexPath.row
        cell.lineView.isHidden = indexPath.row == 1
        
        if option == .music {
            cell.switchControl.isOn = Settings.shared.isMusicOn
        } else if option == .sound {
            cell.switchControl.isOn = Settings.shared.isSoundsOn
        }
        
        return cell
    }
    
    
}
