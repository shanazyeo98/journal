//
//  ListViewController.swift
//  Journal
//
//  Created by Shanaz Yeo on 10/10/25.
//

import UIKit

class ListViewController: UIViewController {
    
    let tableView: UITableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredLogs: [DayLog] = []
    
    private var isSearching: Bool {
        let hasText = !(searchController.searchBar.text?.isEmpty ?? true)
        let hasScope = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (hasText || hasScope)
    }
    
    private let store = DayLogDataStore.shared
    private var dataSource: UITableViewDiffableDataSource<Group, DayLog>!
    
    private var scopeTitles: [String] = ["All"] + Mood.allCases.map { $0.description }
    private var selectedScope: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Journal"
        configureDataSource()
        tableView.dataSource = dataSource
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(DayJournalTableViewCell.self, forCellReuseIdentifier: DayJournalTableViewCell.identifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEntry))
        configureSearch()
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification,
        object: nil, queue: .main) { [weak self] _ in
                guard let self else { return }
                try? self.store.saveDayLogs()
        }
        applySnapshot()
    }
    
    func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search logs"
        navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = scopeTitles
        searchController.searchBar.delegate = self
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Group, DayLog>(tableView: tableView) { (tableView, indexPath, dayLog) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DayJournalTableViewCell.identifier, for: indexPath) as? DayJournalTableViewCell else { return UITableViewCell() }
            cell.configure(with: dayLog)
            return cell
        }
        
        dataSource.defaultRowAnimation = .fade
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateBackgroundMessage()
//    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Group, DayLog>()
        
        let items = isSearching ? filteredLogs : store.getDayLogs()
        // Group items by type (1)
//        let grouped = Dictionary(grouping: self.store.getDayLogs(), by: { $0.mood })

        // Sort types alphabetically (1)
//        let sortedTypes = grouped.keys.sorted(by: { $0.rawValue < $1.rawValue })

        // Build snapshot
        snapshot.appendSections([Group.section])
        snapshot.appendItems(items)

            // Apply it to the data source
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        self.updateBackgroundMessage()
    }
    
    @objc func addNewEntry() {
        //to display the new entry modal sheet
        let editVC = DayJournalEditViewController(dayLog: nil, delegate: self)
        let navVC = UINavigationController(rootViewController: editVC)
        present(navVC, animated: true)
    }
    
    private func updateBackgroundMessage() {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray2
        if store.getDayLogs().isEmpty {
            label.text = "No items yet. Tap + to add one."
        } else if isSearching && filteredLogs.isEmpty {
            label.text = "No results."
        } else {
            tableView.backgroundView = nil
            return
        }
        tableView.backgroundView = label
    }

}
    
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = isSearching ? filteredLogs : store.getDayLogs()
        let log = items[indexPath.row]
        navigationController?.pushViewController(DayJournalDetailViewController(dayLog: log, delegate: self), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.deleteItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        guard let log = dataSource.itemIdentifier(for: indexPath) else { return nil }

        let delete = UIContextualAction(style: .destructive, title: "Delete") { _,_,done in
            self.store.deleteItem(log)
            self.store.saveDayLogs()
            self.applySnapshot()
            
            done(true)
        }

        return UISwipeActionsConfiguration(actions: [delete])
    }
    
//    private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let type = dataSource.snapshot().sectionIdentifiers[section]
//        return type.rawValue.capitalized
//    }
}

extension ListViewController: DayJournalEditViewControllerDelegate {
    
    func didAddItem(_ log: DayLog) {
        store.addItem(log)
        store.saveDayLogs()
        applySnapshot()
    }
    
    
    func alreadyHasLog(for date: Date) -> Bool {
        return store.getDayLogs().contains { DayLog in
            Calendar.current.isDate(DayLog.date, inSameDayAs: date)
        }
    }
}

extension ListViewController: DayJournalDetailViewControllerDelegate {
    func didUpdateItem(_ log: DayLog) {
        store.updateItem(log)
        store.saveDayLogs()
        applySnapshot()
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.isEmpty && self.selectedScope == 0 {
            applySnapshot()
            return
        }
        
        filteredLogs = selectedScope == 0 ? store.getDayLogs() : store.getDayLogs().filter { item in
            return scopeTitles[selectedScope] == item.mood.description
        }
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredLogs = filteredLogs.filter { item in
                if let description = item.description {
                    return description.lowercased().contains(searchText.lowercased())
                } else { return false }
            }
        }
        applySnapshot()
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.selectedScope = selectedScope
    }
}


#Preview {
    ListViewController()
}
