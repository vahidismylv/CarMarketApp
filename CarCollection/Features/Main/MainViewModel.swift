//
//  MainViewModel.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 02.03.26.
//

import Foundation

final class MainViewModel {

    private let carRepository: CarRepository
    private let favoritesRepository: FavoritesRepository

    private var allItems: [Car] = []
    private(set) var items: [Car] = [] {
        didSet { onUpdate?() }
    }

    private(set) var activeFilters: FiltersResult?

    var onUpdate: (() -> Void)?

    init(carRepository: CarRepository, favoritesRepository: FavoritesRepository) {
        self.carRepository = carRepository
        self.favoritesRepository = favoritesRepository
    }

    func load() {
        allItems = carRepository.fetchCars()
        items = allItems
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
    }

    func detailViewModel(at index: Int) -> CarDetailViewModel? {
        let car = item(at: index)
        guard let detail = carRepository.fetchDetail(id: car.id) else { return nil }
        return CarDetailViewModel(car: detail, favoritesRepository: favoritesRepository)
    }

    func applySearch(_ text: String) {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !query.isEmpty else {
            applyActiveFilters()
            return
        }

        let filteredBase = filteredItems(using: activeFilters, from: allItems)
        items = filteredBase.filter { car in
            car.name.lowercased().contains(query) ||
            car.model.lowercased().contains(query) ||
            car.location.lowercased().contains(query)
        }
    }

    func setFilters(_ filters: FiltersResult?) {
        activeFilters = filters
        applyActiveFilters()
    }

    private func applyActiveFilters() {
        items = filteredItems(using: activeFilters, from: allItems)
    }

    private func filteredItems(using filters: FiltersResult?, from source: [Car]) -> [Car] {
        guard let filters else { return source }

        return source.filter { car in
            if !filters.bodyTypes.isEmpty {
                let body = car.bodyType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let allowed = filters.bodyTypes.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                if !allowed.contains(body) { return false }
            }

            if let min = filters.minPrice, let price = parseMoneyToInt(car.price), price < min {
                return false
            }

            if let max = filters.maxPrice, let price = parseMoneyToInt(car.price), price > max {
                return false
            }

            if let min = filters.minYear, let year = Int(car.date.trimmingCharacters(in: .whitespacesAndNewlines)), year < min {
                return false
            }

            if let max = filters.maxYear, let year = Int(car.date.trimmingCharacters(in: .whitespacesAndNewlines)), year > max {
                return false
            }

            if !filters.fuelTypes.isEmpty {
                let fuel = car.fuelType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let allowed = filters.fuelTypes.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                if !allowed.contains(fuel) { return false }
            }

            if !filters.transmissions.isEmpty {
                let transmission = car.transmission.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let allowed = filters.transmissions.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                if !allowed.contains(transmission) { return false }
            }

            if let min = filters.minMileage, car.mileage < min {
                return false
            }

            if let max = filters.maxMileage, car.mileage > max {
                return false
            }

            return true
        }
    }

    private func parseMoneyToInt(_ text: String) -> Int? {
        let digits = text.compactMap { $0.isNumber ? $0 : nil }
        return Int(String(digits))
    }
}
