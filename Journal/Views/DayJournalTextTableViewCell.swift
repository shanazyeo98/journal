//
//  DayJournalTextTableViewCell.swift
//  Journal
//
//  Created by Shanaz Yeo on 13/10/25.
//

import UIKit

class DayJournalTextTableViewCell: UITableViewCell {
    
    static let identifier: String = "DayJournalEditTextCell"
    let inputTextField: UITextView = UITextView()
    
    var onTextChanged: ((String?) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.font = UIFont.preferredFont(forTextStyle: .body)
        inputTextField.isScrollEnabled = true
        inputTextField.textContainerInset = (UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        inputTextField.delegate = self
        contentView.addSubview(inputTextField)
        contentView.layer.masksToBounds = true //clip the sublayer to its bounds to not overspill
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            inputTextField.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configure(input: String?, enabled: Bool) {
        inputTextField.text = input ?? ""
        if !enabled {
            inputTextField.isEditable = false
        }
    }
    
    //behaviour when cell is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DayJournalTextTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textField: UITextView) {
        onTextChanged?(textField.text)
    }
}
