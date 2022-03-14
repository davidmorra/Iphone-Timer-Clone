//
//  TimerProgressView.swift
//  Timer
//
//  Created by Davit on 02.03.22.
//

import UIKit

class TimerProgressView: UIView {
    let progressCircle = ProgressCircle()
    var timeView = TimeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        style()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layout()
        style()
    }
    
    fileprivate func style() {
        progressCircle.translatesAutoresizingMaskIntoConstraints = false

        timeView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    fileprivate func layout() {
        addSubview(timeView)
        
        if UIScreen.main.bounds.width < 700 {
            addSubview(progressCircle)
            
            NSLayoutConstraint.activate([
                progressCircle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                progressCircle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                
                timeView.centerYAnchor.constraint(equalTo: progressCircle.centerYAnchor),
                timeView.centerXAnchor.constraint(equalTo: progressCircle.centerXAnchor),
            ])
            
        } else if UIScreen.main.bounds.width > 700 {
            timeView.timeLabel.font = UIFont.systemFont(ofSize: 82, weight: .thin)
            timeView.timerEndView.timerEndLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            
            NSLayoutConstraint.activate([
                timeView.centerYAnchor.constraint(equalTo: centerYAnchor),
                timeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
        }
    }
}
