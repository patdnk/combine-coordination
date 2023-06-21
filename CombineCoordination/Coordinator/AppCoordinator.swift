import Foundation
import Combine
import UIKit

extension AppCoordinator {
    indirect enum Environment: Equatable {
        case dev
        case staging
        case production
    }
}

extension AppCoordinator {
    indirect enum Event: Equatable {
        case initial
        case invalid
        case willStartFeatureScreens
        case didFinishFeatureScreens
        case willStartFinishScreen
        
    }
}

final class AppCoordinator: Coordinator<Void> {
    
    private var window: UIWindow?
    private var environment: Environment
    private let result = PassthroughSubject<CoordinationResult, Never>()
    
    init(environment: Environment = .dev) {
        self.environment = environment
    }
    
    // MARK: - Coordinator
    func start(window: UIWindow?) -> AnyPublisher<CoordinationResult, Never> {
        self.window = window
        loop(event: .initial)
        return result
            .eraseToAnyPublisher()
    }
    
    public func loop(event: Event) {
        
        let newEvent = type(of: self).fsm(event: event)
        
        switch newEvent {
        case .willStartFeatureScreens:
            guard let window = window else { preconditionFailure("No UIWindow to attach")  }
            FeatureCoordinator.init(window: window).start(coordinator: self)
            
        case .willStartFinishScreen:
            
            window?.rootViewController = FinitoViewController.instantiateFromStoryboard()
            window?.makeKeyAndVisible()

        default:
            preconditionFailure("Invalid flow event")
        }
        
    }
    
    
}

extension AppCoordinator {
    static func fsm(event: Event) -> Event {
        switch event {
        case .initial:
            return .willStartFeatureScreens
            
        case .didFinishFeatureScreens:
            return .willStartFinishScreen
            
        default:
            return .invalid
            
        }
    }
}

extension AppCoordinator {
    var fsm: Subscribers.Sink<AppCoordinator.Event, Never> {
        return Subscribers.Sink<AppCoordinator.Event, Never>(
            receiveCompletion: { _ in },
            receiveValue:{ [unowned self] event in
                self.loop(event: event)
            }
        )
    }
}

