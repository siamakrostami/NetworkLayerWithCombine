
import Alamofire
import Combine
import Foundation

// MARK: - ViewModel

class ViewModel {
    // MARK: Lifecycle

    deinit {
        NetworkManager.destroy()
        debugPrint("viewmodel deinited")
    }

    // MARK: Internal

    var error = CurrentValueSubject<AFError?, Never>(nil)
    var registerModel = CurrentValueSubject<RegisterDomainModel?, Never>(nil)
    var disposeBag = Set<AnyCancellable>()
}

extension ViewModel {
    // MARK: - Register User

    // call your api for registration from network manager
    func registerUserWith(username: String, password: String) {
        NetworkManager.shared.authenticationRepository?.registrationService?
            .registerUser(username: username, password: password)
            .subscribe(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] errorCompletion in
                switch errorCompletion {
                case .failure(let error):
                    self?.error.send(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] model in
                self?.registerModel.send(model)
            })
            .store(in: &self.disposeBag)
    }
}
