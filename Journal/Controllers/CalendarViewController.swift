////
////  CalendarViewController.swift
////  Journal
////
////  Created by Shanaz Yeo on 14/10/25.
////
//
//import UIKit
//
//class CalendarViewController: UIViewController {
//    
//    let logs: [DayLog]
//    let calendarView: UICalendarView = UICalendarView()
//    
//    init(logs: [DayLog]) {
//        self.logs = logs
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        setupUI()
//        setupConstraints()
//    }
//    
//    func setupUI() {
//        calendarView.translatesAutoresizingMaskIntoConstraints = false
//        calendarView.calendar = Calendar(identifier: .gregorian)
//        calendarView.tintColor = .systemPink
//        calendarView.delegate = self
//        view.addSubview(calendarView)
//        
//    }
//    
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            calendarView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//
//}
//
//extension CalendarViewController: UICalendarViewDelegate {
//    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
//        if let log = logs.first(where: { log in
//            let logDateComponent = Calendar.current.dateComponents([.year, .month, .day], from: log.date)
//            return logDateComponent.year == dateComponents.year && logDateComponent.month == dateComponents.month && logDateComponent.day == dateComponents.day
//        }) {
//            if let photo = log.photo {
//                return .customView {
//                        let imageView = UIImageView(image: photo)
//                        imageView.contentMode = .scaleAspectFill
//                        imageView.clipsToBounds = true
//                        imageView.layer.cornerRadius = 6
//                        // 📌 Provide intrinsicContentSize so UIKit can size it
//                        let container = UIView()
//                        container.addSubview(imageView)
//                        imageView.translatesAutoresizingMaskIntoConstraints = false
//                        NSLayoutConstraint.activate([
//                            imageView.topAnchor.constraint(equalTo: container.topAnchor),
//                            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
//                            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
//                            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
//                        ])
//
//                        return container
//                    }
//            }
//        }
//        return nil
//    }
//}
//
//#Preview {
//    CalendarViewController(logs: [DayLog(date: Date(), photo: UIImage(named: "coffee"), description: "Had fun today!", mood: .good)])
//}
