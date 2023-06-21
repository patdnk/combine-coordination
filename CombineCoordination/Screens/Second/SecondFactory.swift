import UIKit
import Combine

struct SecondFactory {
    
    static func start(coordinator: FeatureCoordinator,
                      pageViewController: UIPageViewController,
                      direction: UIPageViewController.NavigationDirection) {
        
        let viewModel = SecondViewModel()
        let viewController = SecondViewController.instantiateFromStoryboard()
        viewController.viewModel = viewModel
        
        // VM Binding
        viewModel.flows.completion
            .map {fsm(event: $0) }
            .receive(subscriber: coordinator.fsm)

        pageViewController.setViewControllers([viewController],
                                              direction: direction,
                                              animated: true,
                                              completion: nil)
        
    }
}

extension SecondFactory {
    static func fsm(event: SecondViewModel.Event) -> FeatureCoordinator.Event {
        switch event {
        case .didCompleteSecond:
            return .didShowSecond
        }
    }
}


