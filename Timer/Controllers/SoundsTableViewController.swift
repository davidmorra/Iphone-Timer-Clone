//
//  SoundsTableViewController.swift
//  Timer
//
//  Created by Davit on 01.03.22.
//

import UIKit

struct Sounds {
    let name: String
    var isSelected: Bool = false
}

class SoundsTableViewController: UITableViewController {

    let sounds = ["Silk", "Ripples", "Timba", "Slow rise", "Harp", "Piano notes", "Guitar", "John Cena", "Tatara taa", "Shalaxo", "Nescafe", "Sound 2", "Another sound"]
    
    var soundsArray = [Sounds]()
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sounds"
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))

        for i in sounds {
            let sound = Sounds(name: i)
            soundsArray.append(sound)
        }
        
        soundsArray[selectedRow].isSelected = true

    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func doneButtonTapped() {
        let sound = soundsArray.filter { $0.isSelected == true }
        print("You picked sound \(sound[0].name)")
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return soundsArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "STORE"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return "1. $9.99/month after trial. Offer good for 3 months after eligible device activation. One subscription per Family Sharing group. Plan automatically renews until cancelled. Restrictions and other terms apply."
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return tableView.estimatedRowHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell") else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath) as? SoundTableViewCell else { return UITableViewCell() }

            cell.sound = soundsArray[indexPath.row]
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard indexPath.section == 1 else { return }
        
        if selectedRow == indexPath.row { return }
        
        if let _ = tableView.cellForRow(at: IndexPath(row: selectedRow, section: 1)) {
            soundsArray[selectedRow].isSelected = false
            tableView.reloadRows(at: [IndexPath(row: selectedRow, section: 1)], with: .none)
        }
        
        if let _ = tableView.cellForRow(at: indexPath) {
            soundsArray[indexPath.row].isSelected = true
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 1)], with: .none)
        }

        selectedRow = indexPath.row
    }
    
}
