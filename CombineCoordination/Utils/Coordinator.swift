import Foundation
import Combine

public protocol AnyCoordinator: AnyObject {
    var identifier: UUID { get }
}

extension Coordinator {
    public enum DisposingStrategy {
        case onAll
        case onDispose
    }
}

/// Base abstract coordinator generic over the return type of the `start` method.
open class Coordinator<Result>: AnyCoordinator, CombineCancellableHolder {
    public typealias CoordinationResult = Result

    // MARK: - Props

    public let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    public var disposingStrategy: DisposingStrategy = .onAll

    // MARK: - Init

    public init() {}

    // MARK: - Methods

    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. Depending on the `disposingStrategy` then on `start()` removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    public func coordinate<T>(to coordinator: Coordinator<T>) -> AnyPublisher<T, Never> {
        store(coordinator: coordinator)

        let disposingBlock: (() -> Void) = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else { return }

            self?.free(coordinator: coordinator)
        }

        switch disposingStrategy {
        case .onAll:
            return coordinator.start()
                .handleOnAll(disposingBlock)
                .eraseToAnyPublisher()
        case .onDispose:
            return coordinator.start()
                .handleOnDispose(disposingBlock)
                .eraseToAnyPublisher()
        }
    }

    public func coordinateAndSubscribe<T>(to coordinator: Coordinator<T>, resultHandler: ((T) -> Void)? = nil) {
        coordinate(to: coordinator)
            .sink(receiveValue: { value in resultHandler?(value) })
            .store(in: &cancellables)
    }

    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    open func start() -> AnyPublisher<Result, Never> {
        fatalError("Start method should be implemented.")
    }

    // MARK: - Private Methods

    private func store(coordinator: AnyCoordinator) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free(coordinator: AnyCoordinator) {
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }
}
