//
//  SettingsController.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/28/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    var modelIdentifier: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    
    var hasHapticFeedback: Bool {
        if !modelIdentifier.contains("iPhone") {
            return false
        }
        
        let subString = String(modelIdentifier[modelIdentifier.index(modelIdentifier.startIndex, offsetBy: 6)..<modelIdentifier.endIndex])
        
        if let generationNumberString = subString.components(separatedBy: ",").first,
            let generationNumber = Int(generationNumberString),
            generationNumber >= 9 {
            return true
        }
        
        return false
    }
    
}

class SettingsController: BaseController {
    private let baseHeight: CGFloat = 100
    private let cellHeight: CGFloat = 50
    
    enum Setting: Int {
        case music
        case sound
        case vibration
        case exit
    }
    
    private var options: [Setting] = []
    private var withExit: Bool = false
    private let vibrationAvailable: Bool = UIDevice.current.hasHapticFeedback
    
    @IBOutlet weak var itemsCollection: UICollectionView!
    @IBOutlet weak var heightConstaint: NSLayoutConstraint!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        options.append(.music)
        options.append(.sound)
        
        if vibrationAvailable {
            options.append(.vibration)
        }
        
        if withExit {
            options.append(.exit)
        }
        
        heightConstaint.constant = baseHeight + CGFloat(options.count) * cellHeight
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    class func controller(withExit: Bool = false) -> SettingsController? {
        if let controller = R.storyboard.settings.settingsController() {
            controller.withExit = withExit
            return controller
        }
        
        return nil
    }
    
    // MARK: - Actions
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchAction(sender: UISwitch) {
        guard let option = Setting(rawValue: sender.tag) else { return }
        
        switch option {
        case .music:
            Settings.shared.isMusicOn = sender.isOn
        case .sound:
            Settings.shared.isSoundsOn = sender.isOn
        case .vibration:
            Settings.shared.isVibrationOn = sender.isOn
        default:
            break
        }
    }
}

extension SettingsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let option = options[indexPath.row]
        
        switch option {
        case .exit:
            LandingController.show(withUpdate: false)
        case .music:
            Settings.shared.isMusicOn = !Settings.shared.isMusicOn
        case .sound:
            Settings.shared.isSoundsOn = !Settings.shared.isSoundsOn
        case .vibration:
            Settings.shared.isVibrationOn = !Settings.shared.isVibrationOn
        }
        
        collectionView.reloadItems(at: [indexPath])
        
        return false
    }
    
    func titleAtOption(option: Setting) -> String {
        switch option {
        case .music:
            return "Музыка"
        case .sound:
            return "Звуки"
        case .vibration:
            return "Вибрация"
        case .exit:
            return "Выход"
        }
    }
    
    func iconImageAtOption(option: Setting) -> UIImage? {
        switch option {
        case .music:
            return R.image.musicIcon()
        case .sound:
            return R.image.soundIcon()
        case .vibration:
            return R.image.vibrationIcon()
        case .exit:
            return R.image.exitIcon()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SettingsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCellID", for: indexPath) as! SettingsCell
        
        let option = options[indexPath.row]
        
        cell.titleLabel.text = self.titleAtOption(option: option)
        cell.iconImageView.image = self.iconImageAtOption(option: option)
        cell.switchControl.tag = option.rawValue
        cell.lineView.isHidden = indexPath.row == options.count - 1
        
        if option == .music {
            cell.switchControl.isOn = Settings.shared.isMusicOn
        } else if option == .sound {
            cell.switchControl.isOn = Settings.shared.isSoundsOn
        } else if option == .vibration {
            cell.switchControl.isOn = Settings.shared.isVibrationOn
        }
        
        cell.switchControl.isHidden = option == .exit
        
        return cell
    }
    
    
}


