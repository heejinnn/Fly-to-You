//
//  FlightMapViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import FirebaseFirestore

protocol FlightMapViewModelInput {
    func fetchAllFlights(completion: @escaping (Result<Void, Error>) -> (Void))
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
    
    func fetchAllFlights(completion: @escaping (Result<Void, Error>) -> (Void)){
        Task {
            do {
                let flightsData = try await useCase.execute()
                self.flights = flightsData
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

extension DefaultFlightMapViewModel{
    var flightsPublisher: Published<[FlightModel]>.Publisher{
        $flights
    }
}

extension User {
    static let unknown = User(uid: "unknown", nickname: "(Unknown)", createdAt: Date())
}
