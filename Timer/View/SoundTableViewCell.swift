//
//  SoundTableViewCell.swift
//  Timer
//
//  Created by Davit on 01.03.22.
//

import UIKit

class SoundTableViewCell: UITableViewCell {

    @IBOutlet weak var soundLabel: UILabel! {
        didSet {
            soundLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    @IBOutlet weak var checkmark: UIImageView!
    
    let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold))
    
    var sound: Sounds? {
        didSet {
            guard let sound = sound else {
                return
            }

            soundLabel.text = sound.name
            checkmark.image = sound.isSelected ? checkmarkImage : UIImage()
        }
    }
    
}
