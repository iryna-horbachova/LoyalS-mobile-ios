//
//  CategoryTableViewCell.swift
//  LoyalS
//


import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
