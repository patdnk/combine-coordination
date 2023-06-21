import UIKit
import Combine

struct FirstFactory {
    
    static func start(coordinator: FeatureCoordinator,
                      pageViewController: UIPageViewController,
                      direction: UIPageViewController.NavigationDirection) {
        
        let viewModel = FirstViewModel()
        let viewController = FirstViewController.instantiateFromStoryboard()
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

extension FirstFactory {
    static func fsm(event: FirstViewModel.Event) -> FeatureCoordinator.Event {
        switch event {
        case .didCompleteFirst:
            return .didShowFirst
        }
    }
}


