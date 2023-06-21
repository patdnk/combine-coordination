import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet private(set) weak var actionButton: UIButton!
    
    var viewModel: SecondViewModel!

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
        
    }
    
    @objc func tapAction() {
        viewModel.inputs.actionTapped()
    }

}

extension SecondViewController: Storyboarded {
    static var storyboardName: String { return "Second" }
    static var storyboardIdentifier: String { return "Second" }
}
