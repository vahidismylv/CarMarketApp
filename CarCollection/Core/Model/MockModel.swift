//
//  MockModel.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 14.02.26.
//

import Foundation


struct Car {
    let id: UUID
    let date: String
    let name: String
    let model: String
    let location: String
    let price: String
    let fuelType: String
    let transmission: String
    let bodyType: String
    let imageName: String
    let mileage: Int
}

struct CarDetail {
    let id: UUID
    
    let date: String
    let name: String
    let model: String
    let location: String
    let price: String
    
    let engine: String
    let fuelType: String
    let transmission: String
    let bodyType: String
    let powerHP: Int
    let powerKW: Int
    let origin: String
    let mileage: String
    let cubicCapacity: String
    let fuelConsumption: String
    let seats: Int
    let doors: Int
    let color: String
    
    let imageNames: [String]
    let description: String
    
    let seller: Seller
}

struct Seller {
    let name: String
    let phone: String
}

struct FiltersResult {
    let minPrice: Int?
    let maxPrice: Int?
    let minYear: Int?
    let maxYear: Int?
    let minMileage: Int?
    let maxMileage: Int?
    let bodyTypes: [String]
    let fuelTypes: [String]
    let transmissions: [String]
}
