//
//  CustomTableViewCell.swift
//  DynamicHeightTableView
//
//  Created by Swayam Patel on 12/04/25.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.numberOfLines = 0 // Allow unlimited lines
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = .systemFont(ofSize: 16)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    func configure(with text: String) {
        contentLabel.text = text
    }
}
