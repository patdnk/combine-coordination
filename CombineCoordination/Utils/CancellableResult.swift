import Foundation

public enum CancellableResult<T> {
    case success(T)
    case cancel
}

extension CancellableResult: Equatable where T: Equatable {}

public extension CancellableResult {
    var value: T? {
        switch self {
        case let .success(value): return value
        case .cancel: return nil
        }
    }

    var isCancelled: Bool {
        switch self {
        case .success: return false
        case .cancel: return true
        }
    }

    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .cancel: return false
        }
    }
}
