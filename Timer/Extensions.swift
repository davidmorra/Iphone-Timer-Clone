//
//  ButtonConfiguration.swift
//  Timer
//
//  Created by Davit on 25.02.22.
//

import UIKit

func tupleOfSecondsToString(_ time: (Int, Int, Int)) -> String {
    var timeString = ""
    
    if time.0 > 0 {
        timeString += String(format: "%02d", time.0)
        timeString += ":"
    }
    timeString += String(format: "%02d", time.1)
    timeString += ":"
    timeString += String(format: "%02d", time.2)

    return timeString
}

func tupleOfSecondsToSeconds(_ time: (Int, Int, Int)) -> Int {
    let time = ((time.0 * 60) * 60, 60 * time.1, time.2)

    return time.0 + time.1 + time.2
}

func timerEndTime(time: (Int, Int, Int)) -> String {
    let currentTimeShared = CurrentTime.shared
    let currentTime = currentTimeShared.getCurrentTime()
    
    var hour = currentTime.hour + time.0
    var minutes = currentTime.min + time.1
    var seconds = currentTime.sec
    
    if time.2 + seconds > 60 {
        minutes += 1
        seconds = 60 - time.2
    } else if minutes >= 60 {
        minutes = minutes - 60
        hour += 1
    }
    
    if hour >= 24 {
        hour = 0
    }
        
    var timeLabel = ""
    timeLabel += String(format: "%02d", hour)
    timeLabel += ":"
    timeLabel += String(format: "%02d", minutes)
    
    return timeLabel
}

extension UIButton {
    func changeColor(to color: UIColor, _ title: String) {
        
        self.setTitle(title, for: .normal)
        self.configuration?.baseForegroundColor = color
        self.configuration?.baseBackgroundColor = color
    }
    
    func isDisabled(_ disabled: Bool = false) {
        if disabled {
            self.isUserInteractionEnabled = false
            self.configuration?.baseBackgroundColor = .systemGreen.withAlphaComponent(0.5)
        } else {
            self.isUserInteractionEnabled = true
            self.configuration?.baseBackgroundColor = .systemGreen.withAlphaComponent(1)
        }
    }
    
    func allowTextToScale(minFontScale: CGFloat = 0.5, numberOfLines: Int = 1) {
//        if UIScreen.main.bounds.height < 670 {
//            self.transform = CGAffineTransform(scaleX: minFontScale, y: minFontScale)
//        }
        
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = minFontScale - 0.05
        self.titleLabel?.numberOfLines = numberOfLines
    }
}

extension UILabel {    
    func configureColor(with color: UIColor) {
        return self.textColor = color
    }
}

extension Int {
    func secondsToTime() -> String {
        let time = ((self / 360000) % 60, ((self / 6000) % 60), (self / 100) % 60, self % 100)
        
        var timeString = ""
        
        if time.0 > 0 {
            timeString += String(format: "%02d", time.0)
            timeString += ":"
        }
        
        timeString += String(format: "%02d", time.1)
        timeString += ":"
        timeString += String(format: "%02d", time.2)
        timeString += ","
        timeString += String(format: "%02d", time.3)

        return timeString
    }
    
    func timerSecondsToString() -> String {
        let time = ((self / 3600) % 60, (self % 3600) / 60, self % 60)
        
        var timeString = ""
        
        if time.0 > 0 {
            timeString += String(format: "%02d", time.0)
            timeString += ":"
        }
        
        timeString += String(format: "%02d", time.1)
        timeString += ":"
        timeString += String(format: "%02d", time.2)

        return timeString
    }
}
