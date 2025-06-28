//
//  FlightMapViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import FirebaseFirestore

protocol FlightMapViewModelInput {
    func observeAllFlights()
    func removeFlightsListener()
}

protocol FlightMapViewModelOutput {
    var flightsPublisher: Published<[FlightModel]>.Publisher { get }
}

protocol FlightMapViewModel: FlightMapViewModelInput, FlightMapViewModelOutput {}


final class DefaultFlightMapViewModel: FlightMapViewModel {
    @Published var flights: [FlightModel] = []

    private let useCase: FetchFlightsUseCase
    
    init(useCase: FetchFlightsUseCase){
        self.useCase = useCase
    }
    
    func observeAllFlights() {
        useCase.observeAllFlights { [weak self] flights in
            self?.flights = flights
        }
    }
    
    func removeFlightsListener() {
        useCase.removeFlightsListener()
    }
}

extension DefaultFlightMapViewModel{
    var flightsPublisher: Published<[FlightModel]>.Publisher{
        $flights
    }
}

extension User {
    static let unknown = User(uid: "unknown", nickname: "(Unknown)", createdAt: Date(), fcmToken: "")
}
