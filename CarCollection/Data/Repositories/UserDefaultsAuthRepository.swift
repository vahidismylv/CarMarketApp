import Foundation

protocol AuthRepository {
    func currentSession() -> UserSession?
    func signIn(email: String, password: String) throws -> UserSession
    func signOut()
}

final class UserDefaultsAuthRepository: AuthRepository {

    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let userEmail = "userEmail"
        static let userPassword = "userPassword"
    }

    private let storage: UserDefaults

    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }

    func currentSession() -> UserSession? {
        let isLoggedIn = storage.bool(forKey: Keys.isLoggedIn)
        guard isLoggedIn, let email = storage.string(forKey: Keys.userEmail) else {
            return nil
        }

        return UserSession(email: email)
    }

    func signIn(email: String, password: String) throws -> UserSession {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedEmail.isEmpty, !normalizedPassword.isEmpty else {
            throw AuthError.emptyCredentials
        }

        guard Self.isValidEmail(normalizedEmail) else {
            throw AuthError.invalidEmail
        }

        guard normalizedPassword.count >= 6 else {
            throw AuthError.shortPassword(minLength: 6)
        }

        let savedEmail = storage.string(forKey: Keys.userEmail)
        let savedPassword = storage.string(forKey: Keys.userPassword)

        if let savedEmail, let savedPassword {
            guard savedEmail.lowercased() == normalizedEmail.lowercased(), savedPassword == normalizedPassword else {
                throw AuthError.invalidCredentials
            }
        } else {
            storage.set(normalizedEmail, forKey: Keys.userEmail)
            storage.set(normalizedPassword, forKey: Keys.userPassword)
        }

        storage.set(true, forKey: Keys.isLoggedIn)
        return UserSession(email: normalizedEmail)
    }

    func signOut() {
        storage.set(false, forKey: Keys.isLoggedIn)
        storage.removeObject(forKey: Keys.userEmail)
        storage.removeObject(forKey: Keys.userPassword)
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
}
