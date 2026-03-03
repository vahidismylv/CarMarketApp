import Foundation

final class CarDetailViewModel {

    private let favoritesRepository: FavoritesRepository
    let car: CarDetail

    var onFavoriteChanged: ((Bool) -> Void)?

    init(car: CarDetail, favoritesRepository: FavoritesRepository) {
        self.car = car
        self.favoritesRepository = favoritesRepository
    }

    var imageNames: [String] {
        car.imageNames
    }

    var isFavorite: Bool {
        favoritesRepository.contains(id: car.id.uuidString)
    }

    var specs: [(String, String)] {
        [
            ("Engine", car.engine),
            ("Power", "\(car.powerHP) HP / \(car.powerKW) kW"),
            ("Origin", car.origin),
            ("Mileage", car.mileage),
            ("Cubic capacity", car.cubicCapacity),
            ("Fuel consumption", car.fuelConsumption),
            ("Seats", "\(car.seats)"),
            ("Doors", "\(car.doors)"),
            ("Color", car.color)
        ]
    }

    var quickStats: [(String, String, String)] {
        [
            ("bolt.car", "\(car.powerHP) HP", "Power"),
            ("speedometer", car.mileage, "Mileage"),
            ("fuelpump", car.fuelType, "Fuel"),
            ("gearshape", car.transmission, "Gearbox")
        ]
    }

    var formattedLocation: String {
        "📍 \(car.location)"
    }

    func toggleFavorite() {
        favoritesRepository.toggle(id: car.id.uuidString)
        onFavoriteChanged?(isFavorite)
    }

    func contactPhoneURL() -> URL? {
        let cleaned = car.seller.phone
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")

        return URL(string: "tel://\(cleaned)")
    }
}
