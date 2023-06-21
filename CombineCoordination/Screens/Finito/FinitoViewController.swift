import UIKit

class FinitoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FinitoViewController: Storyboarded {
    static var storyboardName: String { return "Finito" }
    static var storyboardIdentifier: String { return "Finito" }
}

