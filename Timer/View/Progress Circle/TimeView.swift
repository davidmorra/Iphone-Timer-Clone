//
//  TimeView.swift
//  Timer
//
//  Created by Davit on 05.03.22.
//

import UIKit

class TimeView: UIView {
    let timeLabel = UILabel()
    let timerEndView = TimerEndView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func style() {
        timeLabel.text = "00:00"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.systemFont(ofSize: 68, weight: .thin)
        
        timerEndView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        addSubview(timeLabel)
        addSubview(timerEndView)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            timerEndView.topAnchor.constraint(equalToSystemSpacingBelow: timeLabel.bottomAnchor, multiplier: 0),
            timerEndView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomAnchor.constraint(equalToSystemSpacingBelow: timerEndView.bottomAnchor, multiplier: 1)
        ])
    }
}
