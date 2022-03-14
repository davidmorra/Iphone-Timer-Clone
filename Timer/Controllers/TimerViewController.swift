//
//  TimerViewController.swift
//  Timer
//
//  Created by Davit on 01.03.22.
//

import UIKit

enum CircleTimerState {
    case started
    case paused
    case resumed
}

class TimerViewController: UIViewController {
    var timer = TimerObject()
    
    var timerProgressView = TimerProgressView()
    
    @IBOutlet weak var pickerStackView: UIStackView!
    @IBOutlet weak var timePickerView: UIPickerView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startPauseButton: UIButton! {
        didSet {
            startPauseButton.isDisabled(true)
        }
    }
    
    @IBOutlet weak var soundTableView: UITableView!
        var circleTimerState: CircleTimerState?
    
    var count = (0, 0, 0)
    
    var timerCount = 0 {
        didSet {
            if timerCount == 0 {
                timerCount = 0
                timer.invalidate()
                cancelButtonTapped(())
                NotificationManager.shared.sendNotification()
            }
        }
    }

    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.shared.notificationCenter.delegate = self
        
        soundTableView.delegate = self
        soundTableView.dataSource = self
        
        circleTimerState = .none
        
        setUpPickerLabels()
        
        setUpTimerCircleView()
        
        timerProgressView.isHidden = true
        timerProgressView.alpha = 0
        
        timePickerView.alpha = 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIScreen.main.bounds.width > 700 {
            pickerStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3).isActive = true
        } else {
            pickerStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
        }
        
        startPauseButton.allowTextToScale(minFontScale: 0.9, numberOfLines: 1)
        cancelButton.allowTextToScale(minFontScale: 0.9, numberOfLines: 1)
    }
    
    func setUpTimerCircleView() {
        view.insertSubview(timerProgressView, at: 0)

        timerProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerProgressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            timerProgressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            timerProgressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            timerProgressView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: 44),
        ])
    }
    
    func setUpPickerLabels() {
        timePickerView.delegate = self
        timePickerView.dataSource = self

        timePickerView.selectRow(count.1, inComponent: 1, animated: false)
        timePickerView.selectRow(count.2, inComponent: 2, animated: false)
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        timerProgressView.progressCircle.duration = timerCount
        
        updateTimerEndTime()
        
        if circleTimerState == nil {
            circleTimerState = .started
            timerProgressView.progressCircle.startCircleAnimation()
        }

        switch circleTimerState {
        case .started:
            circleTimerState = .paused
            
            startPauseButton.changeColor(to: .systemOrange, "Pause")
            cancelButton.isEnabled = true
            
            timer.startTimer(timeIntervar: 1, selector: #selector(fireTimer), target: self)
            
        case .paused:
            
            startPauseButton.changeColor(to: .systemGreen, "Resume")
            cancelButton.isEnabled = true
            
            timerProgressView.timeView.timerEndView.bellImageView.tintColor = .systemGray3.withAlphaComponent(0.5)
            timerProgressView.timeView.timerEndView.timerEndLabel.textColor = .label.withAlphaComponent(0.5)
            
            timer.invalidate()
            circleTimerState = .resumed
            
        case .resumed:
            
            startPauseButton.changeColor(to: .systemOrange, "Pause")
            timer.startTimer(timeIntervar: 1, selector: #selector(fireTimer), target: self)
            
            updateTimerEndTime()
            timerProgressView.timeView.timerEndView.timerEndLabel.text = timerEndTime(time: count)
            
            timerProgressView.isHidden = true
            timePickerView.isHidden = false
            
            timerProgressView.timeView.timerEndView.bellImageView.tintColor = .systemGray3.withAlphaComponent(1)
            timerProgressView.timeView.timerEndView.timerEndLabel.textColor = .label.withAlphaComponent(1)
            
            circleTimerState = .paused
        case .none:
            startPauseButton.changeColor(to: .systemGreen, "Start")
            cancelButton.isEnabled = false
            
            circleTimerState = .started
        }
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.timerProgressView.isHidden = false
            self?.timerProgressView.alpha = 1
            self?.timePickerView.alpha = 0
            self?.timePickerView.isHidden = true
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        // after canceling timer and starting again, time label was incorect
        timerCount = tupleOfSecondsToSeconds(count)
        timerProgressView.timeView.timeLabel.text = tupleOfSecondsToString(count)
        
        
        updateTimerEndTime()
        
        timer.invalidate()
        circleTimerState = .none
        
        switch circleTimerState {
        case .none:
            cancelButton.isEnabled = false
        default:
            cancelButton.isEnabled = true
        }
        
        startPauseButton.changeColor(to: .systemGreen, "Start")
                
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.timerProgressView.isHidden = true
            self?.timePickerView.isHidden = false
            
            self?.timerProgressView.alpha = 0
            self?.timePickerView.alpha = 1
        }
    }
    
    func updateTimerEndTime() {
        let currentTime = CurrentTime.shared
        currentTime.updateTime()
        
        timerProgressView.timeView.timerEndView.timerEndLabel.text = timerEndTime(time: count)
    }
}

// MARK: - Setup Timer
extension TimerViewController {
    @objc func fireTimer() {
        timerCount -= 1
        
        timerProgressView.timeView.timeLabel.text = timerCount.timerSecondsToString()
    }
}

extension TimerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSounds", sender: nil)
        
//        present(SoundsTableViewController(), animated: true)
    }
}

extension TimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        }
        return minutes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = String(row)
        label.textAlignment = .center
                
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0: count.0 = hours[row]
        case 1: count.1 = minutes[row]
        case 2: count.2 = seconds[row]
        default: break
        }
                
        timerCount = tupleOfSecondsToSeconds(count)
        timerProgressView.timeView.timeLabel.text = tupleOfSecondsToString(count)
        
        if timerCount == 0 {
            startPauseButton.isDisabled(true)
        } else if timerCount > 0 {
            startPauseButton.isDisabled(false)
        }
    }
}

extension TimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }

}
