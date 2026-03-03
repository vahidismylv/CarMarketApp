//
//  CarCollectionTests.swift
//  CarCollectionTests
//
//  Created by Vahid Ismayilov on 12.02.26.
//

import Foundation
import Testing
@testable import CarCollection

struct CarCollectionTests {

    @Test func authRepositoryStoresSessionAfterFirstSignIn() throws {
        let defaults = UserDefaults(suiteName: "CarCollectionTests.authRepositoryStoresSessionAfterFirstSignIn")!
        defaults.removePersistentDomain(forName: "CarCollectionTests.authRepositoryStoresSessionAfterFirstSignIn")

        let repository = UserDefaultsAuthRepository(storage: defaults)
        let session = try repository.signIn(email: "tester@example.com", password: "secret1")

        #expect(session.email == "tester@example.com")
        #expect(repository.currentSession()?.email == "tester@example.com")
    }

    @Test func authRepositoryRejectsInvalidCredentialsForExistingUser() throws {
        let defaults = UserDefaults(suiteName: "CarCollectionTests.authRepositoryRejectsInvalidCredentialsForExistingUser")!
        defaults.removePersistentDomain(forName: "CarCollectionTests.authRepositoryRejectsInvalidCredentialsForExistingUser")

        let repository = UserDefaultsAuthRepository(storage: defaults)
        _ = try repository.signIn(email: "tester@example.com", password: "secret1")

        #expect(throws: AuthError.self) {
            try repository.signIn(email: "tester@example.com", password: "wrongpw")
        }
    }

    @Test func mainViewModelFiltersCarsBySearchText() {
        let viewModel = MainViewModel(
            carRepository: MockCarRepository(),
            favoritesRepository: UserDefaultsFavoritesRepository(
                storage: UserDefaults(suiteName: "CarCollectionTests.mainViewModelFiltersCarsBySearchText")!
            )
        )

        viewModel.load()
        viewModel.applySearch("audi")

        #expect(viewModel.numberOfItems() == 1)
        #expect(viewModel.item(at: 0).name == "Audi")
    }

}
