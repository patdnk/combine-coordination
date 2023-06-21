import Combine
import Foundation

public extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        on object: T
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }

    func sink() -> AnyCancellable {
        sink { _ in }
    }

    func assign<S: Subject>(
        on subject: S
    ) -> AnyCancellable where S.Failure == Failure, S.Output == Output {
        sink { value in subject.send(value) }
    }
}
