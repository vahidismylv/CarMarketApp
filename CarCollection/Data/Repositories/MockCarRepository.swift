//
//  MockCarRepository.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 02.03.26.
//
import UIKit

protocol CarRepository {
    func fetchCars() -> [Car]
    func fetchDetail(id: UUID) -> CarDetail?
}

final class MockCarRepository: CarRepository {

    func fetchCars() -> [Car] {
        MockData.cars
    }

    func fetchDetail(id: UUID) -> CarDetail? {
        MockData.detail(for: id)
    }
}
