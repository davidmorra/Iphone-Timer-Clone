//
//  CurrentTime.swift
//  Timer
//
//  Created by Davit on 04.03.22.
//

import Foundation

class CurrentTime {
    static let shared = CurrentTime()
    var date = Date()
    var calendar = Calendar.current
    
    func getCurrentTime() -> (hour: Int, min: Int, sec: Int) {
//        let date = Date()
//        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        return (hour, minutes, seconds)
    }
    
    func updateTime() {
        date = Date.now
        calendar = Calendar.current
    }
}
