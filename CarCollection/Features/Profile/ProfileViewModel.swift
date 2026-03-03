import Foundation

final class ProfileViewModel {

    private let authRepository: AuthRepository

    private(set) var session: UserSession? {
        didSet { onUpdate?() }
    }

    var onUpdate: (() -> Void)?

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func loadProfile() {
        session = authRepository.currentSession()
    }

    func logout() {
        authRepository.signOut()
        session = nil
    }

    var displayName: String {
        session?.email ?? "Guest"
    }

    var subtitle: String {
        session == nil ? "Please log in to access your profile" : "Welcome back"
    }

    var isLoggedIn: Bool {
        session != nil
    }
}
