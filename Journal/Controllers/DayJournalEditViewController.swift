//
//  DayJournalEditViewController.swift
//  Journal
//
//  Created by Shanaz Yeo on 13/10/25.
//

import UIKit

class DayJournalEditViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let dayLog: DayLog?
    let imageView: UIImageView = UIImageView()
    let headerViewHeight: CGFloat = 300
    let imageSide: CGFloat = 200
    let headerView: UIView = UIView()
    let headerViewPadding: CGFloat = 16
    let footerView: UIView = UIView()
    var tempLog: DayLog
    
    let changeImageButton: UIButton = UIButton()
//    lazy var selectedImage: UIImage? = dayLog?.photo
    
    var delegate: DayJournalEditViewControllerDelegate?
    
    init(dayLog: DayLog?, delegate: DayJournalEditViewControllerDelegate?) {
        self.dayLog = dayLog
        self.delegate = delegate
        self.tempLog = dayLog ?? DayLog()
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(dayLog != nil ? "Edit" : "Add") Day Journal"
        tableView.register(DayJournalTextTableViewCell.self, forCellReuseIdentifier: DayJournalTextTableViewCell.identifier)
        tableView.register(DayJournalDateTableViewCell.self, forCellReuseIdentifier: DayJournalDateTableViewCell.identifier)
        tableView.register(DayJournalMoodTableViewCell.self, forCellReuseIdentifier: DayJournalMoodTableViewCell.identifier)
        tableView.register(DayJournalStatsTableViewCell.self, forCellReuseIdentifier: DayJournalStatsTableViewCell.identifier)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveData))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        setupImage()
        setupButton()
        setupConstraints()
    }

    
    func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        if let image = dayLog?.photo {
            imageView.image = image
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
            let placeholderImage = UIImage(systemName: "photo", withConfiguration: config)
            imageView.image = placeholderImage
            imageView.tintColor = .systemGray4
        }
        headerView.addSubview(imageView)
    }
    
    func getConfigurationForButton() -> UIButton.Configuration {
        var config = UIButton.Configuration.glass()
        config.background.backgroundColor = .systemPink
        config.baseForegroundColor = .white
        return config
    }
    
    func setupButton() {
        changeImageButton.setTitle("Change Image", for: .normal)
        changeImageButton.configuration = getConfigurationForButton()
        changeImageButton.tintColor = .systemBlue
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        headerView.addSubview(changeImageButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: headerViewPadding),
            imageView.heightAnchor.constraint(equalToConstant: imageSide),
            imageView.widthAnchor.constraint(equalToConstant: imageSide),
            imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            changeImageButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            changeImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            changeImageButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        headerView.setNeedsLayout() // mark a view for layout update
        headerView.layoutIfNeeded() //forces a view to update its layout immediately if a layout update is pending and updates the size
            
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height //determine the min size needed for the its contents
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)
        tableView.tableHeaderView = headerView
    }
    
    @objc func saveData() {
        guard let delegate else { return }
        
        if dayLog == nil {
            if (delegate.alreadyHasLog(for: tempLog.date)) {
                let alert = UIAlertController(title: "Error", message: "There is already an existing entry for this date.", preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(cancelAction)
                present(alert, animated: true)
                return
            }
            delegate.didAddItem(tempLog)
        } else {
            delegate.didUpdateItem(tempLog)
        }
        dismiss(animated: true)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func photoButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickImageAction = UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                guard let self else { return }
                self.presentImagePicker(sourceType: .camera)
            }
            alert.addAction(pickImageAction)
        }
        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            guard let self else { return }
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        alert.addAction(chooseFromLibraryAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = changeImageButton
        }
        present(alert, animated: true)
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = sourceType
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        present(imagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            tempLog.photo = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            tempLog.photo = originalImage
        }
        imageView.image = tempLog.photo
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Date"
        case 1:
            return "Description"
        case 2:
            return "Mood"
        case 3:
            return "Stats"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case (0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DayJournalDateTableViewCell.identifier, for: indexPath) as? DayJournalDateTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(date: tempLog.date, enabled: dayLog != nil ? false : true)
            cell.onDateChanged = { [weak self] date in
                guard let self else { return }
                self.tempLog.date = date
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DayJournalTextTableViewCell.identifier, for: indexPath) as? DayJournalTextTableViewCell else {
                return  UITableViewCell()}
            cell.configure(input: tempLog.description, enabled: true)
            cell.onTextChanged = { [weak self] text in
                self?.tempLog.description = text
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DayJournalMoodTableViewCell.identifier, for: indexPath) as? DayJournalMoodTableViewCell else { return UITableViewCell() }
            cell.configure(mood: tempLog.mood)
            cell.onValueChanged = {[weak self] mood in
                guard let self else { return }
                self.tempLog.mood = mood
            }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DayJournalStatsTableViewCell.identifier, for: indexPath) as? DayJournalStatsTableViewCell else { return UITableViewCell() }
            cell.configure(labelName: "☕️ Coffee", counterValue: tempLog.coffeeDrank)
            cell.onValueChanged = {[weak self] coffees in
                guard let self else { return }
                self.tempLog.coffeeDrank = coffees
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 128
        case (1, 0):
            return 80
        case (2, 0):
            return 96
        case (3, 0):
            return 48
        default:
            return 0
        }
    }

}

protocol DayJournalEditViewControllerDelegate: AnyObject {
    func didAddItem(_ log: DayLog)
    func didUpdateItem(_ log: DayLog)
    func alreadyHasLog(for date: Date) -> Bool
}

extension DayJournalEditViewControllerDelegate {
    func didAddItem(_ log: DayLog) {}
    func didUpdateItem(_ log: DayLog) {}
    func alreadyHasLog(for date: Date) -> Bool { return false }
}

#Preview {
    DayJournalEditViewController(dayLog: nil, delegate: nil)
}
