//
//  ProgressCircle.swift
//  Timer
//
//  Created by Davit on 04.03.22.
//

import UIKit

class ProgressCircle: UIView {
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

    let timer = TimerObject()
    
    var progress: CGFloat = 1.0
    var duration = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircuralPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircuralPath()
    }
    
    func createTimer() {
        timer.startTimer(timeIntervar: 0.001, selector: #selector(timerSelector), target: nil)
    }
    
    @objc func timerSelector() {
        progress -= 0.0001
    }
    
    fileprivate func createCircuralPath() {
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: UIScreen.main.bounds.width/2 - 16, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.systemGray4.cgColor
        trackLayer.lineWidth = 6
        trackLayer.lineCap = .round
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.systemOrange.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.speed = 1
        shapeLayer.strokeEnd = progress
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)
    }
    
    func startCircleAnimation() {
        basicAnimation.toValue = 0
        
        basicAnimation.duration = CFTimeInterval(duration)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "circle")
    }
    
    func pauseAnimation() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0
        layer.timeOffset = pausedTime
    }

    func resumeAnimation(){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
