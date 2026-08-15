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
    @IBOutlet weak var chevronImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 14)

        
        contentLabel.numberOfLines = 0 // Allow unlimited lines
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = .systemFont(ofSize: 16)
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
        
        UIView.animate(withDuration: 0.2) {
            self.chevronImageView.transform = isExpanded
                ? CGAffineTransform(rotationAngle: .pi)
                : .identity
        }

    }
    
    
    
}
