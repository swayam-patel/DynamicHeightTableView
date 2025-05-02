//
//  ViewController.swift
//  DynamicHeightTableView
//
//  Created by Swayam Patel on 12/04/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Table View Demos"
        
        // Create a vertical stack view for buttons
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Dynamic Height Table View button
        let dynamicButton = UIButton(type: .system)
        dynamicButton.setTitle("Dynamic Height Table View", for: .normal)
        dynamicButton.addTarget(self, action: #selector(showDynamicHeight), for: .touchUpInside)
        
        // Expandable Table View button
        let expandableButton = UIButton(type: .system)
        expandableButton.setTitle("Expandable Table View", for: .normal)
        expandableButton.addTarget(self, action: #selector(showExpandable), for: .touchUpInside)
        
        stackView.addArrangedSubview(dynamicButton)
        stackView.addArrangedSubview(expandableButton)
        
        // Center the stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showDynamicHeight() {
        let vc = DynamicHeightViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showExpandable() {
        let vc = ExpandableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
