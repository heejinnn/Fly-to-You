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
    func getParticipationCount(for flight: FlightModel) -> Int
}

protocol FlightMapViewModelOutput {
    var flightsPublisher: Published<[FlightModel]>.Publisher { get }
}

protocol FlightMapViewModel: FlightMapViewModelInput, FlightMapViewModelOutput {}


final class DefaultFlightMapViewModel: FlightMapViewModel {
    @Published var flights: [FlightModel] = []

    private let fetchFlightsUseCase: FetchFlightsUseCase
    private let blockLetterUseCase: BlockLetterUseCase
    private let getParticipationCountUseCase: GetParticipationCountUseCase
    
    init(fetchFlightsUseCase: FetchFlightsUseCase, blockLetterUseCase: BlockLetterUseCase, getParticipationCountUseCase: GetParticipationCountUseCase){
        self.fetchFlightsUseCase = fetchFlightsUseCase
        self.blockLetterUseCase = blockLetterUseCase
        self.getParticipationCountUseCase = getParticipationCountUseCase
    }
    
    func observeAllFlights() {
        fetchFlightsUseCase.observeAllFlights { [weak self] flights in
            self?.flights = flights
        }
    }
    
    func removeFlightsListener() {
        fetchFlightsUseCase.removeFlightsListener()
    }
    
    func blockLetter(letterId: String){
        Task {
            try await blockLetterUseCase.blockLetter(letterId: letterId)
            removeFlightsListener()
            observeAllFlights()
        }
    }
    
    func getParticipationCount(for flight: FlightModel) -> Int {
        return getParticipationCountUseCase.execute(for: flight)
    }
}

extension DefaultFlightMapViewModel{
    var flightsPublisher: Published<[FlightModel]>.Publisher{
        $flights
    }
}
