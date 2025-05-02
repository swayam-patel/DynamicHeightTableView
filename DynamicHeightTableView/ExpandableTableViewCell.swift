//
//  ExpandableTableViewCell.swift
//  DynamicHeightTableView
//
//  Created by Swayam Patel on 12/04/25.
//

import UIKit

class ExpandableTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentStack: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 14)

        
        contentLabel.numberOfLines = 0 // Allow unlimited lines
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = .systemFont(ofSize: 16)
        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            
//            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
//        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    func configure(title: String, content: String, isExpanded: Bool) {
        titleLabel.text = title
        contentLabel.text = content
        
        let previousHidden = contentLabel.isHidden
        contentLabel.isHidden = !isExpanded
        
        
        if previousHidden != contentLabel.isHidden {
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
        }
    }
    
    
    
}
