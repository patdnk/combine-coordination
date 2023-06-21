import UIKit

public protocol Storyboarded {

    static var storyboardName: String { get }

    static var storyboardIdentifier: String { get }
}

extension Storyboarded {

    public static var storyboardIdentifier: String { return String(describing: self) }
}

extension Storyboarded where Self: UIViewController {

    public static func instantiateFromStoryboard() -> Self {

        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)

        guard let viewController: Self
            = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier)
                as? Self else {

                    fatalError("Failed to instantiate view controller \(storyboardIdentifier)"
                        + " from storyboard \(storyboardName)")
        }

        return viewController
    }
}
