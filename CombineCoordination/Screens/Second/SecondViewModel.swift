import Foundation
import Combine

class SecondViewModel: CombineCancellableHolder {
    
    let inputs: Inputs
    let outputs: Outputs
    let flows: Flows
    
    // MARK: - Init
    init() {
        
        // Inputs
        let actionTapped = PassthroughSubject<Event, Never>()
        inputs = Inputs(actionTappedSubscriber: actionTapped)
        
        // Outputs
        let actionTitle = Just("2 > finish").eraseToAnyPublisher()
        outputs = Outputs(actionTitle: actionTitle)
        
        //Flows
        let completion = actionTapped
        flows = Flows(completion: completion)
        
    }
    
}


// MARK: - Events / Flows
extension SecondViewModel {
    
    enum Event {
        case didCompleteSecond
    }
    
    struct Outputs {
        let actionTitle: AnyPublisher<String, Never>
    }
    
    struct Inputs {
        let actionTappedSubscriber: PassthroughSubject<Event, Never>
        func actionTapped() {
            actionTappedSubscriber.send(.didCompleteSecond)
        }
    }
    
    struct Flows {
        let completion: PassthroughSubject<Event, Never>
    }
    
}
