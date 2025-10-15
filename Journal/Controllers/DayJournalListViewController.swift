//
//  ListViewController.swift
//  Journal
//
//  Created by Shanaz Yeo on 10/10/25.
//

import UIKit

class ListViewController: UIViewController {
    
    let tableView: UITableView = UITableView()
    
    var dayLogs: [DayLog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Journal"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DayJournalTableViewCell.self, forCellReuseIdentifier: DayJournalTableViewCell.identifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEntry))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    @objc func addNewEntry() {
        //to display the new entry modal sheet
        let editVC = DayJournalEditViewController(dayLog: nil, delegate: self)
        let navVC = UINavigationController(rootViewController: editVC)
        present(navVC, animated: true)
    }

}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayJournalTableViewCell.identifier, for: indexPath) as? DayJournalTableViewCell else { return UITableViewCell()}
        cell.configure(with: dayLogs[indexPath.row])
        return cell
    }
}
    
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = dayLogs[indexPath.row]
        navigationController?.pushViewController(DayJournalDetailViewController(dayLog: log), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dayLogs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ListViewController: DayJournalEditViewControllerDelegate {
    
    func didAddItem(_ log: DayLog) {
        dayLogs.append(log)
        dayLogs.sort { $0.date < $1.date }
        tableView.reloadData()
    }
    
    func alreadyHasLog(for date: Date) -> Bool {
        return dayLogs.contains { DayLog in
            Calendar.current.isDate(DayLog.date, inSameDayAs: date)
        }
    }
}

#Preview {
    ListViewController()
}
