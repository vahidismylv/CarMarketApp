import Foundation

final class FavoritesViewModel {

    private let carRepository: CarRepository
    private let favoritesRepository: FavoritesRepository

    private(set) var items: [Car] = [] {
        didSet { onUpdate?() }
    }

    var onUpdate: (() -> Void)?

    init(carRepository: CarRepository, favoritesRepository: FavoritesRepository) {
        self.carRepository = carRepository
        self.favoritesRepository = favoritesRepository
    }

    func loadFavorites() {
        let ids = Set(favoritesRepository.getIDs())
        items = carRepository.fetchCars().filter { ids.contains($0.id.uuidString) }
    }

    func numberOfItems() -> Int {
        items.count
    }

    func item(at index: Int) -> Car {
        items[index]
    }

    func isFavorite(at index: Int) -> Bool {
        favoritesRepository.contains(id: item(at: index).id.uuidString)
    }

    func toggleFavorite(at index: Int) {
        favoritesRepository.toggle(id: item(at: index).id.uuidString)
        loadFavorites()
    }

    func detailViewModel(at index: Int) -> CarDetailViewModel? {
        let car = item(at: index)
        guard let detail = carRepository.fetchDetail(id: car.id) else { return nil }
        return CarDetailViewModel(car: detail, favoritesRepository: favoritesRepository)
    }
}
