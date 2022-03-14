//
//  StopwatchViewController.swift
//  Timer
//
//  Created by Davit on 24.02.22.
//

import UIKit

enum TimerState {
    case started
    case stopped
    case reseted
}

class StopwatchViewController: UIViewController {
    var timer = TimerObject()
    var timerCount = 0 {
        didSet {
            if timerCount > 8640000 {
                timerCount = 0
            }
        }
    }
    
    var secondTimerCount = 0 {
        didSet {
            if secondTimerCount > 8640000 {
                secondTimerCount = 0
            }
        }
    }

    var timerState: TimerState?
    
    var minimum = 1
    var maximum = 4
        
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var lapTableView: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playStopButton: UIButton!
    @IBOutlet weak var lapResetButton: UIButton!
    
    var lapsArray = [Laps]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lapTableView.delegate = self
        lapTableView.dataSource = self
        lapTableView.allowsSelection = false
                
        timerLabel.text = "00:00,00"
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 82, weight: .thin)
        
        lapResetButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIScreen.main.bounds.width > 700 {
            timeStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3 ).isActive = true
        } else {
            timeStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
        }

        playStopButton.allowTextToScale(minFontScale: 0.9, numberOfLines: 1)
        lapResetButton.allowTextToScale(minFontScale: 0.9, numberOfLines: 1)
    }

    
    //MARK: - Start Stop Button
    @IBAction func playStopButtonTapped(_ sender: Any) {
        if timerState == nil || timerState == .stopped {
            timerState = .started
            
            if lapsArray.isEmpty {
                let lap = Laps(seconds: timerCount)
                lapsArray.append(lap)
            }

            lapTableView.reloadData()
            
        } else if timerState == .started {
            timerState = .stopped
        } else if timerState == .reseted {
            timerState = nil
        }
        
        timerStateConfiguration()
    }
    
    //MARK: - Lap Reset Button Action
    @IBAction func lapResetButtonTapped(_ sender: UIButton) {
        if timerState == .started {
            lapResetButton.isEnabled = true
            
            let lap = Laps(seconds: secondTimerCount)
            lapsArray.insert(lap, at: lapsArray.count)
            
            lapTableView.reloadData()
            
        } else if timerState == .stopped {
            lapResetButton.isEnabled = false
            timerCount = 0
            timerLabel.text = timerCount.secondsToTime()
            lapsArray.removeAll()
            lapTableView.reloadData()
        }

        secondTimerCount = 0
    }
    
    //MARK: - Timer State Configuration
    func timerStateConfiguration() {
        switch timerState {
        case .started:
            playStopButton.changeColor(to: .systemRed, "Stop")
                        
            lapResetButton.setTitle("Laps", for: .normal)
            lapResetButton.isEnabled = true
            
            timer.startTimer(timeIntervar: 0.01, selector: #selector(fireTimer), target: self)
            
        case .stopped:
            timer.invalidate()
            
            playStopButton.changeColor(to: .systemGreen, "Start")
            
            lapResetButton.setTitle("Reset", for: .normal)
            
        case .reseted:
            timer.invalidate()
            
            playStopButton.changeColor(to: .systemGreen, "Start")
            lapResetButton.setTitle("Lap", for: .normal)
            
        case .none:
            timer.invalidate()
            
            playStopButton.changeColor(to: .systemGreen, "Start")
            
            lapResetButton.setTitle("Lap", for: .normal)

        }
    }
    
    //MARK: - Timer Setup
    @objc func fireTimer() {
        timerCount += 1
        secondTimerCount += 1

        timerLabel.text = timerCount.secondsToTime()
        
        guard let cell = lapTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LapTableViewCell else { return }
        
        cell.timeLabel.text = secondTimerCount.secondsToTime()
        cell.timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .regular)
    }
}

extension StopwatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var max = lapsArray.map { $0.seconds }.max() ?? 0
        var min = lapsArray.map { $0.seconds }.min() ?? 2

        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as? LapTableViewCell else { return UITableViewCell() }

            cell.lapCountLabel.text = "Round \(lapsArray.count)"

            return cell
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath) as? LapTableViewCell else { return UITableViewCell() }
            
            let seconds = lapsArray[(lapsArray.count - 1) - indexPath.row + 1].seconds
            cell.timeLabel.text = seconds.secondsToTime()
            cell.lapCountLabel.text = "Round \((lapsArray.count - 1) - indexPath.row + 1)"
            
            print(min, max)
            return cell
        }
    }
}
