//
//  SettingsController.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/28/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

class SettingsController: BaseController {
    @IBOutlet weak var itemsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SettingsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCellID", for: indexPath) as! SettingsCell
        return cell
    }
}
