import Foundation
import Combine

extension Publisher {

    public func handleEvents(
        receiveSubscription: ((Subscription) -> Void)? = nil,
        receiveOutput: ((Self.Output) -> Void)? = nil,
        receiveOnDispose: (() -> Void)? = nil,
        receiveRequest: ((Subscribers.Demand) -> Void)? = nil
    ) -> Publishers.HandleEvents<Self> {
        handleEvents(
            receiveSubscription: receiveSubscription,
            receiveOutput: receiveOutput,
            receiveCompletion: { _ in receiveOnDispose?() },
            receiveCancel: receiveOnDispose,
            receiveRequest: receiveRequest
        )
    }

    public func handleOnDispose(_ onDispose: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(
            receiveCompletion: { _ in onDispose() },
            receiveCancel: { onDispose() })
    }

    public func handleOnAll(_ onAll: @escaping (() -> Void)) -> Publishers.HandleEvents<Self> {
        handleEvents(
            receiveOutput: { _ in onAll() },
            receiveOnDispose: { onAll() }
        )
    }
}
