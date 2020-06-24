import UIKit

// Cell to display user's history of bought discounts

class UsedDiscountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var discountTitle: UILabel!
    
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var discountImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

