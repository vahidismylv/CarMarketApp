//
//  MockData.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 20.02.26.
//

import UIKit

enum MockData {

    static let cars: [Car] = [
        Car(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            date: "2021",
            name: "BMW",
            model: "F10",
            location: "Baku",
            price: "$52,000",
            fuelType: "Petrol",
            transmission: "RWD",
            bodyType: "Sedan",
            imageName: "bmwm5",
            mileage: 42000
        ),
        Car(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            date: "2020",
            name: "Mercedes",
            model: "W205",
            location: "Ganja",
            price: "$48,500",
            fuelType: "Petrol",
            transmission: "AWD",
            bodyType: "Sedan",
            imageName: "c63",
            mileage: 35000
        ),
        Car(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            date: "2019",
            name: "Audi",
            model: "RS7",
            location: "Sumqayit",
            price: "$61,900",
            fuelType: "Petrol",
            transmission: "AWD",
            bodyType: "Sedan",
            imageName: "rs7",
            mileage: 75000
        )
    ]


    static let carDetails: [UUID: CarDetail] = {

        var dict: [UUID: CarDetail] = [:]

        let bmw = cars[0]
        dict[bmw.id] = CarDetail(
            id: bmw.id,
            date: bmw.date,
            name: bmw.name,
            model: bmw.model,
            location: bmw.location,
            price: bmw.price,
            engine: "4.4L V8 Twin Turbo",
            fuelType: bmw.fuelType,
            transmission: bmw.transmission,
            bodyType: bmw.bodyType,
            powerHP: 600,
            powerKW: 441,
            origin: "Germany",
            mileage: "35,000 km",
            cubicCapacity: "4395 cc",
            fuelConsumption: "10.5 L/100km",
            seats: 5,
            doors: 4,
            color: "Black",
            imageNames: ["bmwm5", "f90p1", "f90p2","f90p3","f90p4","f90p5"],
            description: "Powerful sports sedan in excellent condition. Clean interior, strong engine, ready to drive.",
            seller: Seller(name: "Brendan Johnson", phone: "+994501021002")
        )

        let merc = cars[1]
        dict[merc.id] = CarDetail(
            id: merc.id,
            date: merc.date,
            name: merc.name,
            model: merc.model,
            location: merc.location,
            price: merc.price,
            engine: "4.0L V8 Biturbo",
            fuelType: merc.fuelType,
            transmission: merc.transmission,
            bodyType: merc.bodyType,
            powerHP: 510,
            powerKW: 375,
            origin: "Germany",
            mileage: "42,000 km",
            cubicCapacity: "3982 cc",
            fuelConsumption: "11.2 L/100km",
            seats: 5,
            doors: 4,
            color: "Gray",
            imageNames: ["c63p1", "c63", "c63p2","c63p3"],
            description: "AMG sedan with strong performance. Well maintained, great sound, comfortable ride.",
            seller: Seller(name: "Brendan Johnson", phone: "+994502111001")
        )
        
        let audi = cars[2]
        dict[audi.id] = CarDetail(
            id: audi.id,
            date: audi.date,
            name: audi.name,
            model: audi.model,
            location: audi.location,
            price: audi.price,
            engine: "4.0L V8 TFSI",
            fuelType: audi.fuelType,
            transmission: audi.transmission,
            bodyType: audi.bodyType,
            powerHP: 600,
            powerKW: 441,
            origin: "Germany",
            mileage: "75,000 km",
            cubicCapacity: "3996 cc",
            fuelConsumption: "11.6 L/100km",
            seats: 5,
            doors: 5,
            color: "Black",
            imageNames: ["rs7", "rs7p1", "rs7p2", "rs7p3","rs7p4"],
            description: "RS7 with quattro AWD and strong acceleration. Clean body, premium interior, well maintained.",
            seller: Seller(name: "Elvin Aliyev", phone: "+994501234567")
        )
        
        

        return dict
    }()

    static func detail(for id: UUID) -> CarDetail? {
        carDetails[id]
    }
}
