import Foundation

struct UserSession {
    let email: String
}

enum AuthError: LocalizedError {
    case emptyCredentials
    case invalidEmail
    case shortPassword(minLength: Int)
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .emptyCredentials:
            return "Please fill in email and password"
        case .invalidEmail:
            return "Please enter a valid email"
        case let .shortPassword(minLength):
            return "Password must be at least \(minLength) characters"
        case .invalidCredentials:
            return "Wrong email or password"
        }
    }
}
