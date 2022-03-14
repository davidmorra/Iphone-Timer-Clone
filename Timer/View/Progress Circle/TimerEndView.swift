//
//  TimerEndView.swift
//  Timer
//
//  Created by Davit on 05.03.22.
//

import UIKit

class TimerEndView: UIView {
    let timerEndLabel = UILabel()
    let bellImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func style() {
        timerEndLabel.text = "00:00"
        
        timerEndLabel.translatesAutoresizingMaskIntoConstraints = false
        timerEndLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        bellImageView.translatesAutoresizingMaskIntoConstraints = false
        bellImageView.image = UIImage(systemName: "bell.fill")
        bellImageView.tintColor = .systemGray3
    }
    
    func layout() {
        addSubview(timerEndLabel)
        addSubview(bellImageView)
        
        NSLayoutConstraint.activate([
            bellImageView.centerXAnchor.constraint(equalTo: leadingAnchor),
            bellImageView.topAnchor.constraint(equalTo: topAnchor),
            
            timerEndLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: bellImageView.trailingAnchor, multiplier: 1),
            timerEndLabel.centerYAnchor.constraint(equalTo: bellImageView.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: timerEndLabel.trailingAnchor, multiplier: 0),
            
            bottomAnchor.constraint(equalToSystemSpacingBelow: timerEndLabel.bottomAnchor, multiplier: 1)
        ])
    }
}

