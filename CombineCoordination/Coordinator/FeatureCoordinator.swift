import UIKit
import Combine

final class FeatureCoordinator: Coordinator<Void> {
    
    private var window: UIWindow
    private let result = PassthroughSubject<CoordinationResult, Never>()
    private let animationDuration: TimeInterval = 0.35
    
    public weak var parent: AppCoordinator?
    
    private var featureViewController: FeatureViewController? {
        (window.rootViewController as? SwipableNavigationController)?.topViewController as? FeatureViewController
    }
    
    // MARK: - Init
    init(
        window: UIWindow
    ) {
        self.window = window
        super.init()
    }
    
    // MARK: - Coordinator
    func start(
        coordinator: Coordinator<Void>
    ) -> AnyPublisher<CoordinationResult, Never> {
        parent = coordinator as? AppCoordinator
        loop(event: .initial)
        return result
            .eraseToAnyPublisher()
        
    }
    
}

extension FeatureCoordinator {
    enum Event: Equatable {
        
        case initial
        case finish
        case invalid
        
        case willShowFirst
        case didShowFirst
        
        case willShowSecond
        case didShowSecond
        
    }
}

extension FeatureCoordinator {
    
    func loop(event: Event) {
        
        let newEvent = type(of: self).fsm(event: event)
        
        switch newEvent {
            
        case .willShowFirst:
            // this initial display could be more elegant but we can sort it due course
            
            // 1. add holding screen
            FeatureFactory.start(
                window: window,
                animationDuration: animationDuration,
                coordinator: self
            )
            
            guard let pageViewController = featureViewController?.pageViewController else { return }
            
            // 2. then inject first screen
            FirstFactory.start(
                coordinator: self,
                pageViewController: pageViewController,
                direction: .forward
                )
            
        case .willShowSecond:
            guard let pageViewController = featureViewController?.pageViewController else { return }
            
            // 2. then inject first screen
            SecondFactory.start(
                coordinator: self,
                pageViewController: pageViewController,
                direction: .forward
                )
            
        case .finish:
            parent?.loop(event: .didFinishFeatureScreens)

        default:
            preconditionFailure("Invalid flow event")
        }
        
    }
    
    static func fsm(event: Event) -> Event {
        switch event {
        case .initial:
            return .willShowFirst
            
        case .didShowFirst:
            return .willShowSecond
            
        case .didShowSecond:
            return .finish

        default:
            return .invalid
        }
    }
}

extension FeatureCoordinator {
    var fsm: Subscribers.Sink<FeatureCoordinator.Event, Never> {
        return Subscribers.Sink<FeatureCoordinator.Event, Never>(
            receiveCompletion: { _ in },
            receiveValue:{ event in
                self.loop(event: event)
            }
        )
    }
}
