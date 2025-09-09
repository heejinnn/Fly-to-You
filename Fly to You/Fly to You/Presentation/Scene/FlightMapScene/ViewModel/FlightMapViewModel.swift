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
    func filterFlights(selectedTab: String, searchTopic: String) async -> [FlightModel]
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
    private let userRepo: UserRepo
    
    init(fetchFlightsUseCase: FetchFlightsUseCase, blockLetterUseCase: BlockLetterUseCase, getParticipationCountUseCase: GetParticipationCountUseCase, userRepo: UserRepo){
        self.fetchFlightsUseCase = fetchFlightsUseCase
        self.blockLetterUseCase = blockLetterUseCase
        self.getParticipationCountUseCase = getParticipationCountUseCase
        self.userRepo = userRepo
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
    
    func filterFlights(selectedTab: String, searchTopic: String) async -> [FlightModel] {
        do {
            let currentUid = try await userRepo.currentUserUid()
            
            return flights.filter { flight in
                let isMyFlight = flight.routes.contains { $0.from.uid == currentUid || $0.to.uid == currentUid }
                let matchesTab = selectedTab == "내 항로" ? isMyFlight : !isMyFlight
                let matchesSearch = searchTopic.isEmpty || flight.topic.localizedCaseInsensitiveContains(searchTopic)
                return matchesTab && matchesSearch
            }
        } catch {
            // 에러 발생 시 빈 배열 반환
            return []
        }
    }
}

extension DefaultFlightMapViewModel{
    var flightsPublisher: Published<[FlightModel]>.Publisher{
        $flights
    }
}
