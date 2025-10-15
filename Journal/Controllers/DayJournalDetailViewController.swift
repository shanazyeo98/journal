//
//  DayJournalViewController.swift
//  Journal
//
//  Created by Shanaz Yeo on 10/10/25.
//

import UIKit

class DayJournalDetailViewController: UITableViewController {

    var dayLog: DayLog
    let cellIdentifier: String = "Cell"
    let imageView: UIImageView = UIImageView()
    let headerView: UIView = UIView()
    var headerViewHeight: CGFloat = 200
    let imageViewPadding: CGFloat = 20
    
    init(dayLog: DayLog) {
        self.dayLog = dayLog
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        setupUI()
        setupConstraints()
        
    }
    
    func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        if let photo = dayLog.photo {
            imageView.image = photo
        } else {
            headerViewHeight = 0
        }
        imageView.layer.cornerRadius = 10
        headerView.addSubview(imageView)
    }
    
    /*TODO: To figure out if there is a way to set the headerView frame to be the height of the calculated imageView.
     On hindsight, UIViewController with UIImageView and UITableView would maybe make more sense?*/
    
    
    func setupConstraints() {
        let imageViewHeight = headerViewHeight - imageViewPadding * 2
        
        if imageViewHeight > 0 {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
                imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: imageViewHeight),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
                imageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20)
            ])
        }
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
            
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)
        tableView.tableHeaderView = headerView
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "General"
        case 1:
            return "Description"
        case 2:
            return "Details"
        default:
            return nil
        }
    }
    
    func getCellForTable(section: Int) -> UITableViewCell {
        switch (section) {
        case 1:
            let cell = DayJournalTextTableViewCell()
            return cell
        default:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = getCellForTable(section: indexPath.section)
            cell.textLabel?.text = "Date"
            cell.detailTextLabel?.text = DateFormatter.localizedString(from: dayLog.date, dateStyle: .medium, timeStyle: .none)
            return cell
        case (1, 0):
            let cell = getCellForTable(section: indexPath.section) as! DayJournalTextTableViewCell
            cell.configure(input: dayLog.description, enabled: false)
            return cell
        case (2, 0):
            let cell = getCellForTable(section: indexPath.section)
            cell.textLabel?.text = "Coffee ☕️"
            cell.detailTextLabel?.text = "\(dayLog.coffeeDrank) cup(s)"
            return cell
        case (2, 1):
            let cell = getCellForTable(section: indexPath.section)
            cell.textLabel?.text = "Mood"
            cell.detailTextLabel?.text = "\(dayLog.mood.rawValue) \(dayLog.mood.description)"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 1:
            return 80
        default:
            return 48
        }
    }
    
    @objc func editButtonTapped() {
        let editVC = DayJournalEditViewController(dayLog: dayLog, delegate: self)
        let navVC = UINavigationController(rootViewController: editVC)
        present(navVC, animated: true)
    }
}

extension DayJournalDetailViewController: DayJournalEditViewControllerDelegate {
    func didUpdateItem(_ log: DayLog) {
        self.dayLog = log
        tableView.reloadData()
    }
}
