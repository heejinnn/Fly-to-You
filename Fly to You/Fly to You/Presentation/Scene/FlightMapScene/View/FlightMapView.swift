//
//  FlightMapView.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI
import Combine

struct FlightMapView: View{
    
    @EnvironmentObject var viewModelWrapper: FlightMapViewModelWrapper
    
    private let segmentedMenu = ["진행 중인 항로", "완료된 항로"]
    @State private var selectedTab = "진행 중인 항로"
    @State private var selectedFlightId: String? = nil
    @State private var showPopup = false
    
    @State private var selectedRoute: ReceiveLetterModel? = nil
    
    var body: some View{
        ZStack {
            ScrollView{
                VStack(spacing: Spacing.md){
                    
                    Spacer()
                    
                    Text("종이 비행기의 여행 경로를 확인해 보세요")
                        .font(.pretendard(.medium, size: 15))
                        .foregroundStyle(.gray3)
                    
                    Picker("", selection: $selectedTab){
                        ForEach(segmentedMenu, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, Spacing.md)
                    
                    
                    ForEach(viewModelWrapper.flights, id: \.id) { flight in
                        PlaneCell(letter: flight.routes[0], participantCount: flight.routes.count, route: .map)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    if selectedFlightId == flight.id {
                                        selectedFlightId = nil
                                    } else {
                                        selectedFlightId = flight.id
                                    }
                                }
                            }
                        
                        if selectedFlightId == flight.id {
                            FlightMapCell(flight: flight) { route in
                                selectedRoute = route
                                showPopup = true
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: selectedFlightId)
                    
                    Spacer()
                }
            }
            if let route = selectedRoute, showPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .zIndex(1)
                
                RoutePopupView(isPresented: $showPopup, route: route)
                    .transition(.scale)
                    .padding(.horizontal, Spacing.md)
                    .onTapGesture { showPopup = false }
                    .zIndex(1)
            }
        }
        .onAppear{
            viewModelWrapper.viewModel.fetchAllFlights{ result in
                switch result{
                case .success():
                    print("[FlightMapView] - 항로 맵 경로 조회 성공")
                case .failure(let error):
                    print("[FlightMapView] - 항로 맵 경로 조회 실패")
                    print(error)
                }
                
            }
        }
        .animation(.easeInOut, value: showPopup)
    }
}

#Preview {
    FlightMapView()
}

final class FlightMapViewModelWrapper: ObservableObject{
    @Published var flights: [FlightModel] = []
    
    var viewModel: FlightMapViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FlightMapViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        viewModel.flightsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.flights, on: self)
            .store(in: &cancellables)
    }
}


