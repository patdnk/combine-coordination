import Foundation
import Combine

class FirstViewModel: CombineCancellableHolder {
    
    let inputs: Inputs
    let outputs: Outputs
    let flows: Flows
    
    // MARK: - Init
    init() {
        
        // Inputs
        let actionTapped = PassthroughSubject<Event, Never>()
        inputs = Inputs(actionTappedSubscriber: actionTapped)
        
        // Outputs
        let actionTitle = Just("1 > 2").eraseToAnyPublisher()
        outputs = Outputs(actionTitle: actionTitle)
        
        //Flows
        let completion = actionTapped
        flows = Flows(completion: completion)
        
    }
    
}


// MARK: - Events / Inputs / Outputs/ Flows
extension FirstViewModel {
    
    enum Event {
        case didCompleteFirst
    }
    
    struct Outputs {
        let actionTitle: AnyPublisher<String, Never>
    }
    
    struct Inputs {
        let actionTappedSubscriber: PassthroughSubject<Event, Never>
        func actionTapped() {
            actionTappedSubscriber.send(.didCompleteFirst)
        }
    }
    
    struct Flows {
        let completion: PassthroughSubject<Event, Never>
    }
    
}
