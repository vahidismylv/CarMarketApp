import Foundation

protocol FavoritesRepository {
    func getIDs() -> [String]
    func contains(id: String) -> Bool
    func toggle(id: String)
    func clear()
}

final class UserDefaultsFavoritesRepository: FavoritesRepository {

    private let storage: UserDefaults
    private let key = "favorite_car_ids"

    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }

    func getIDs() -> [String] {
        storage.stringArray(forKey: key) ?? []
    }

    func contains(id: String) -> Bool {
        getIDs().contains(id)
    }

    func toggle(id: String) {
        var ids = getIDs()
        if ids.contains(id) {
            ids.removeAll { $0 == id }
        } else {
            ids.append(id)
        }
        storage.set(ids, forKey: key)
    }

    func clear() {
        storage.set([], forKey: key)
    }
}
