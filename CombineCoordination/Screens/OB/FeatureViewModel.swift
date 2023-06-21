import Foundation
import Combine

class FeatureViewModel {
    
    // MARK: - Properties
    var currentStep: Step = .first
    
    let inputs: Inputs
    let flows: Flows
    
    // MARK: - Init
    init(initialStep: Step?) {
        currentStep = initialStep ?? .first
        
        // Inputs
        let actionTapped = PassthroughSubject<Event, Never>()
        inputs = Inputs(actionTappedSubscriber: actionTapped)
        
        //Flows
        let completion = actionTapped
        flows = Flows(completion: completion)
        
    }
    
    
    
    // MARK: - Public Methods
    
}

extension FeatureViewModel {
    public enum Step: Int, CaseIterable {
        case first = 0
        case second
    }
}

// MARK: - Events / Flows
extension FeatureViewModel {
    
    enum  Event: Equatable {
        case didShowFeatureScreen
    }
    
    struct Inputs {
        let actionTappedSubscriber: PassthroughSubject<Event, Never>
        func actionTapped() {
            actionTappedSubscriber.send(.didShowFeatureScreen)
        }
    }
    
    struct Flows {
        let completion: PassthroughSubject<Event, Never>
    }
    
}
