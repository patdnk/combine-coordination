import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet private(set) weak var actionButton: UIButton!
    
    var viewModel: FirstViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    private func setupView() {
        actionButton.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.outputs.actionTitle.sink { [weak self] title in
            self?.actionButton.setTitle(title, for: .normal)
        }
        
        viewModel.outputs.actionTitle.sink { [weak self] title in
            self?.actionButton.setTitle(title, for: .normal)
        }
        
    }
    
    @objc func tapAction() {
        viewModel.inputs.actionTapped()
    }

}

extension FirstViewController: Storyboarded {
    static var storyboardName: String { return "First" }
    static var storyboardIdentifier: String { return "First" }
}
