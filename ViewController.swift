//
//  ViewController.swift
//  DynamicHeightTableView
//
//  Created by Swayam Patel on 12/04/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Create the table view
    let tableView = UITableView()
    
    // Sample data with varying lengths
    let data = [
        "Short text",
        "This is a longer piece of text that will wrap to multiple lines.",
        "Even longer text that spans several lines to demonstrate the dynamic height adjustment in the table view cells. This text is designed to be quite lengthy to ensure that the cell expands appropriately to accommodate all the content without truncation."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // Set up the table view
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Constrain the table view to fill the entire screen
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Register the custom cell
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        // Set the data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Enable dynamic row heights
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // Estimated height for performance
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
}
