import Foundation
import Combine

public protocol CombineCancellableHolder {
    var cancellables: [AnyCancellable] { get set }
}

private struct AssociatedKeys {
    static var Cancellables = "CancellablesName"
}

public extension CombineCancellableHolder where Self: AnyObject {
    var cancellables: [AnyCancellable] {
        get {
            PropertyStoring.getAssociatedObject(for: self,
                                                key: &AssociatedKeys.Cancellables) ?? []
        }
        set {
            PropertyStoring.setAssociatedObject(for: self,
                                                key: &AssociatedKeys.Cancellables,
                                                newValue: newValue)
        }
    }
}
