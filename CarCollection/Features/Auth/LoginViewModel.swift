import Foundation

final class LoginViewModel {

    private let authRepository: AuthRepository

    var onLoginSuccess: ((UserSession) -> Void)?
    var onError: ((String) -> Void)?

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func signIn(email: String, password: String) {
        do {
            let session = try authRepository.signIn(email: email, password: password)
            onLoginSuccess?(session)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "Unknown error"
            onError?(message)
        }
    }
}
