//
//  DayJournalDateTableViewCell.swift
//  Journal
//
//  Created by Shanaz Yeo on 13/10/25.
//

import UIKit

class DayJournalDateTableViewCell: UITableViewCell {
    
    static let identifier: String = "DayJournalEditDateCell"
    let picker: UIDatePicker = UIDatePicker()
    var defaultDate: Date = Date()
    let padding: CGFloat = 10
    
    var onDateChanged: ((Date) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        picker.date = defaultDate
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        contentView.addSubview(picker)
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
            picker.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            picker.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            picker.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ])
    }
    
    func configure(date: Date?, enabled: Bool) {
        if let date = date {
            picker.date = date
        }
        if !enabled {
            picker.isUserInteractionEnabled = false
            picker.alpha = 0.5
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        onDateChanged?(sender.date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
