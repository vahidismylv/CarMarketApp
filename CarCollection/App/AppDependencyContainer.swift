import Foundation

final class AppDependencyContainer {

    let carRepository: CarRepository
    let authRepository: AuthRepository
    let favoritesRepository: FavoritesRepository

    init(
        carRepository: CarRepository = MockCarRepository(),
        authRepository: AuthRepository = UserDefaultsAuthRepository(),
        favoritesRepository: FavoritesRepository = UserDefaultsFavoritesRepository()
    ) {
        self.carRepository = carRepository
        self.authRepository = authRepository
        self.favoritesRepository = favoritesRepository
    }

    func makeMainViewModel() -> MainViewModel {
        MainViewModel(
            carRepository: carRepository,
            favoritesRepository: favoritesRepository
        )
    }

    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(
            carRepository: carRepository,
            favoritesRepository: favoritesRepository
        )
    }

    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(authRepository: authRepository)
    }

    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authRepository: authRepository)
    }

    func makeCarDetailViewModel(carID: UUID) -> CarDetailViewModel? {
        guard let detail = carRepository.fetchDetail(id: carID) else {
            return nil
        }

        return CarDetailViewModel(car: detail, favoritesRepository: favoritesRepository)
    }
}
