//
//  DiscountTableViewCell.swift
//  LoyalS
//

import UIKit

class DiscountTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var discountTitleLabel: UILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var startEndDateLabel: UILabel!
    
    @IBOutlet weak var discountImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
