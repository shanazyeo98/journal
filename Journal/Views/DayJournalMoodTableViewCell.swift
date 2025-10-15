//
//  DayJournalMoodTableViewCell.swift
//  Journal
//
//  Created by Shanaz Yeo on 13/10/25.
//

import UIKit

class DayJournalMoodTableViewCell: UITableViewCell {
    
    static let identifier: String = "moodCell"
    let picker: UIPickerView = UIPickerView()
    var onValueChanged: ((Mood) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.masksToBounds = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(picker)
        picker.delegate = self
        picker.dataSource = self
        
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(mood: Mood?) {
        guard let mood else { return }
        let selectedRow = Mood.allCases.firstIndex(of: mood)!
        picker.selectRow(selectedRow, inComponent: 0, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DayJournalMoodTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Mood.allCases.count
    }
}

extension DayJournalMoodTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Mood.allCases[row].rawValue) \(Mood.allCases[row].description)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onValueChanged?(Mood.allCases[row])
    }
}
