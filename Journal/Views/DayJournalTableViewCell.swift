//
//  DayJournalTableViewCell.swift
//  Journal
//
//  Created by Shanaz Yeo on 10/10/25.
//

import UIKit

class DayJournalTableViewCell: UITableViewCell {
    static let identifier: String = "DayJournalTableViewCell"
    let dateLabel = UILabel()
    let moodLabel = UILabel()
    let coffeeLabel = UILabel()
    let descriptionLabel = UILabel()
    let customImageView = UIImageView()
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    let overallStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        dateLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.addArrangedSubview(dateLabel)
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.addArrangedSubview(descriptionLabel)
        coffeeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        coffeeLabel.translatesAutoresizingMaskIntoConstraints = false
        coffeeLabel.textColor = .systemGray
        detailsStackView.addArrangedSubview(coffeeLabel)
        moodLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        moodLabel.translatesAutoresizingMaskIntoConstraints = false
        moodLabel.textColor = .systemGray
        detailsStackView.addArrangedSubview(moodLabel)
        cellStackView.addArrangedSubview(detailsStackView)
        overallStackView.addArrangedSubview(cellStackView)
        customImageView.contentMode = .scaleAspectFill
        customImageView.clipsToBounds = true
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.layer.cornerRadius = 10
        overallStackView.addArrangedSubview(customImageView)
        contentView.addSubview(overallStackView)
        accessoryType = .disclosureIndicator
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            overallStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            overallStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            overallStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            overallStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            customImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            customImageView.widthAnchor.constraint(equalTo: customImageView.heightAnchor, multiplier: 1.0),
            customImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with log: DayLog) {
        dateLabel.text = "📅 \(DateFormatter.localizedString(from: log.date, dateStyle: .medium, timeStyle: .none))"
        moodLabel.text = "Mood : \(log.mood.rawValue)"
        descriptionLabel.text = log.description
        coffeeLabel.text = "☕️ : \(log.coffeeDrank)"
        if let image = log.photo {
            customImageView.image = image
        } else {
            customImageView.image = nil
        }
    }
}
