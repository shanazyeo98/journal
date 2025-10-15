//
//  CalendarDateView.swift
//  Journal
//
//  Created by Shanaz Yeo on 14/10/25.
//

import UIKit

class CalendarDateView: UIView {

    override var intrinsicContentSize: CGSize {
            return CGSize(width: 1, height: 1) // UIKit will scale it to fit the date cell
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .clear
            layer.borderWidth = 2
            layer.borderColor = UIColor.blue.cgColor
            layer.cornerRadius = 6
            clipsToBounds = true
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}
