

import UIKit

// MARK: - ViewController

class ViewController: UIViewController {
    // MARK: Lifecycle

    deinit {
        debugPrint("viewcontroller deinited")
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        bindError()
        bindRegisterModel()
        registerUser(username: "username", password: "password")
        // Do any additional setup after loading the view.
    }

    // MARK: Private

    private let viewModel = ViewModel()
}

extension ViewController {
    private func registerUser(username: String, password: String) {
        viewModel.registerUserWith(username: username, password: password)
    }

    private func bindError() {
        viewModel.error.subscribe(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else {
                    return
                }
                guard let error else {
                    return
                }
                // Show your error
            }
            .store(in: &viewModel.disposeBag)
    }

    private func bindRegisterModel() {
        viewModel.registerModel.subscribe(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self else {
                    return
                }
                guard let model else {
                    return
                }
                // Do sth with your model
            }
            .store(in: &viewModel.disposeBag)
    }
}
