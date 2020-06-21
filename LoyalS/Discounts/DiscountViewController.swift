import UIKit

class DiscountViewController: UIViewController {
    // MARK: - Variables
    
    var discountQRImageURL: URL?
    let activityIndicator = UIActivityIndicatorView()

    // MARK: - Outlets
    
    
    @IBOutlet weak var discountQRImageView: UIImageView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show activity indicator and load discount QR
        Utilities.showActivityIndicator(activityIndicator, view)
        Utilities.loadImage(imageView: discountQRImageView
            , imageURL: discountQRImageURL!)
        Utilities.hideActivityIndicator(activityIndicator)
        
    }

}
