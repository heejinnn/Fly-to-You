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
    func blockLetter(letterId: String)
}

protocol FlightMapViewModelOutput {
    var flightsPublisher: Published<[FlightModel]>.Publisher { get }
}

protocol FlightMapViewModel: FlightMapViewModelInput, FlightMapViewModelOutput {}


final class DefaultFlightMapViewModel: FlightMapViewModel {
    @Published var flights: [FlightModel] = []

    private let useCase: FetchFlightsUseCase
    private let blockLetterUseCase: BlockLetterUseCase
    
    init(useCase: FetchFlightsUseCase, blockLetterUseCase: BlockLetterUseCase){
        self.useCase = useCase
        self.blockLetterUseCase = blockLetterUseCase
    }
    
    func observeAllFlights() {
        useCase.observeAllFlights { [weak self] flights in
            self?.flights = flights
        }
    }
    
    func removeFlightsListener() {
        useCase.removeFlightsListener()
    }
    
    func blockLetter(letterId: String){
        Task {
            try await blockLetterUseCase.blockLetter(letterId: letterId)
            removeFlightsListener()
            observeAllFlights()
        }
    }
}

extension DefaultFlightMapViewModel{
    var flightsPublisher: Published<[FlightModel]>.Publisher{
        $flights
    }
}
