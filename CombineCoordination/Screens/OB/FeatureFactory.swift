import UIKit

struct FeatureFactory {
    
    static func start(window: UIWindow,
                      animationDuration: TimeInterval,
                      coordinator: FeatureCoordinator) {
        
        let viewModel = FeatureViewModel(initialStep: .first)
        let viewController = FeatureViewController(viewModel: viewModel)
        
        // VM Binding
        viewModel.flows.completion
            .map {fsm(event: $0) }
            .receive(subscriber: coordinator.fsm)
        
        let navigationController = SwipableNavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        
        window.rootViewController = navigationController
        UIView.transition(
            with: window,
            duration: animationDuration,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
        
        window.makeKeyAndVisible()
        
    }
}

extension FeatureFactory {
    static func fsm(event: FeatureViewModel.Event) -> FeatureCoordinator.Event {
        switch event {
        case .didShowFeatureScreen:
            return .finish
        }
    }
}
