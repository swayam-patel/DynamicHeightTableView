//
//  ExpandableViewController.swift
//  DynamicHeightTableView
//
//  Created by Swayam Patel on 12/04/25.
//

import UIKit

class ExpandableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Enum to define expansion behavior
    enum ExpansionMode {
        case single
        case multiple
    }
    
    // UI and data properties
    let tableView = UITableView()
    var expansionMode: ExpansionMode = .single
    var expandedIndexPaths: Set<IndexPath> = []

    // Sample data for the table view
    let data: [(title: String, content: String)] = [
        ("Title 1", "This is the content for title 1. It can be multiple lines and will be hidden when the cell is not expanded."),
        ("Title 2", "Content for title 2 is here. This text will only be visible when the cell is expanded."),
        ("Title 3", "For title 3, the content is this text. It will be shown when the user expands the cell."),
        ("Title 4", "Title 4 has its own content. This is a longer piece of text to demonstrate how the cell expands."),
        ("Title 5", "Finally, title 5 has this content. When expanded, the cell will grow to display all of this text.")
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Expandable Table View"
        view.backgroundColor = .white
        
        // Set up table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // Register the nib
        let nib = UINib(nibName: "ExpandableTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ExpandableTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44 // Typical title height + spacing
        
        // Set up navigation bar menu button
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showMenu))
        navigationItem.rightBarButtonItem = menuButton
    }
    
    // MARK: - Menu Actions
    @objc func showMenu(_ sender: UIBarButtonItem) {
        let singleAction = UIAction(title: "Single Cell", state: expansionMode == .single ? .on : .off) { [weak self] _ in
            self?.setExpansionMode(.single)
        }
        let multipleAction = UIAction(title: "Multiple Cell", state: expansionMode == .multiple ? .on : .off) { [weak self] _ in
            self?.setExpansionMode(.multiple)
        }
        let menu = UIMenu(title: "", children: [singleAction, multipleAction])
        sender.menu = menu
    }
    
    private func setExpansionMode(_ mode: ExpansionMode) {
        expansionMode = mode
        let previouslyExpanded = expandedIndexPaths
        expandedIndexPaths.removeAll()
        // Animate the collapse of previously expanded rows
        UIView.animate(withDuration: 0.3) {
            self.tableView.reloadRows(at: Array(previouslyExpanded), with: .none)
            self.tableView.layoutIfNeeded()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableTableViewCell", for: indexPath) as! ExpandableTableViewCell
        let item = data[indexPath.row]
        let isExpanded = expandedIndexPaths.contains(indexPath)
        cell.configure(title: item.title, content: item.content, isExpanded: isExpanded)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var rowsToReload: [IndexPath] = []

        
        if expansionMode == .single {
            // Handle collapse of previous cell and expand of new cell in one animation
            let previousExpanded = expandedIndexPaths.first
            if let prevIndex = previousExpanded, prevIndex != indexPath {
                expandedIndexPaths.remove(prevIndex)
                rowsToReload.append(prevIndex)
            }
            // Toggle the selected cell
            if expandedIndexPaths.contains(indexPath) {
                expandedIndexPaths.remove(indexPath)
            } else {
                expandedIndexPaths.insert(indexPath)
            }
            rowsToReload.append(indexPath)
            
            // Animate both collapse and expand together
            tableView.beginUpdates()
            tableView.reloadRows(at: rowsToReload, with: .automatic)
            tableView.endUpdates()
        } else { // Multiple mode
            // Toggle the selected cell
            if expandedIndexPaths.contains(indexPath) {
                expandedIndexPaths.remove(indexPath)
            } else {
                expandedIndexPaths.insert(indexPath)
            }
            // Animate the change
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
        print("Expanded Index Paths:", expandedIndexPaths)
    }
}
