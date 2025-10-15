//
//  DayJournalStatsTableViewCell.swift
//  Journal
//
//  Created by Shanaz Yeo on 13/10/25.
//

import UIKit

class DayJournalStatsTableViewCell: UITableViewCell {

    static let identifier = "statsCell"
    let label: UILabel = UILabel()
    let counter: UILabel = UILabel()
    let stepper: UIStepper = UIStepper()
    let padding: CGFloat = 16
    let overallStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let stepperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        return stackView
    }()
    
    var onValueChanged: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(overallStackView)
        label.font = .systemFont(ofSize: 18, weight: .bold)
        overallStackView.addArrangedSubview(label)
        counter.font = .systemFont(ofSize: 18, weight: .semibold)
        counter.text = "0"
        stepperStackView.addArrangedSubview(counter)
        stepper.value = 0
        stepper.minimumValue = 0
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(updateStepperValue(_:)), for: .valueChanged)
        stepperStackView.addArrangedSubview(stepper)
        overallStackView.addArrangedSubview(stepperStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            overallStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            overallStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            overallStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            overallStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    func configure(labelName: String, counterValue: Int) {
        label.text = labelName
        counter.text = "\(counterValue)"
        stepper.value = Double(counterValue)
    }
    
    @objc func updateStepperValue(_ sender: UIStepper) {
        counter.text = "\(Int(sender.value))"
        onValueChanged?(Int(sender.value))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


