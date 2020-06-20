import UIKit

class CheckInViewController: UIViewController {
    @IBOutlet weak var checkInLabel: UILabel!
    
    var coinsGained: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        checkInLabel.text = "Thanks for your check in! You've gained \(coinsGained) coins!"
    }

}
