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
    
    private let segmentedMenu = ["내 항로", "둘러보기"]
    @State private var showPopup = false
    @State private var showReportModal = false
    @State private var showBlockAlert = false
    @State private var alertDuplicatedReport = false
    @State private var completeReport = false
    
    @State private var selectedTab = "내 항로"
    @State private var selectedFlightId: String? = nil
    @State private var selectedRoute: ReceiveLetterModel? = nil
    @State private var seachTopic: String = ""
    
    
    var body: some View{
        ZStack {
            ScrollView{
                VStack(spacing: Spacing.md){
                    
                    Spacer()
                    
                    Text("종이 비행기의 여행 경로를 확인해 보세요 🗺️")
                        .font(.pretendard(.medium, size: 15))
                        .foregroundStyle(.gray3)
                    
                    segmentedControl
                    
                    SearchBar(seachText: $seachTopic, searchBarRoute: .searchTopic)
                        .padding(.horizontal, Spacing.md)
                    
                    planeCellSection
                    
                    Spacer()
                }
            }
        
            if let route = selectedRoute, showPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture { showPopup = false }
                
                RoutePopupView(showReportModal: $showReportModal, showBlockAlert: $showBlockAlert, route: route)
                    .transition(.scale)
                    .padding(.horizontal, Spacing.md)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: showPopup)
        .onAppear{
            viewModelWrapper.viewModel.observeAllFlights()
            viewModelWrapper.updateFilteredFlights(selectedTab: selectedTab, searchTopic: seachTopic)
        }
        .onDisappear{
            viewModelWrapper.viewModel.removeFlightsListener()
        }
        .onChange(of: selectedTab) { _, _ in
            viewModelWrapper.updateFilteredFlights(selectedTab: selectedTab, searchTopic: seachTopic)
        }
        .onChange(of: seachTopic) { _, _ in
            viewModelWrapper.updateFilteredFlights(selectedTab: selectedTab, searchTopic: seachTopic)
        }
        .onChange(of: viewModelWrapper.flights.count) { _, _ in
            viewModelWrapper.updateFilteredFlights(selectedTab: selectedTab, searchTopic: seachTopic)
        }
        .sheet(isPresented: $showReportModal) {
            ReportSheetView(letter: selectedRoute, alertDuplicatedReport: $alertDuplicatedReport, completeReport: $completeReport)
                .presentationDragIndicator(.visible)
        }
        .alert("신고가 접수되었습니다. 검토까지는 최대 24시간 소요됩니다!", isPresented: $completeReport) {
            Button("확인") {
                completeReport = false
            }
        }
        .alert("이미 신고된 편지예요. 빠르게 검토 중입니다!", isPresented: $alertDuplicatedReport) {
            Button("확인") {
                alertDuplicatedReport = false
            }
        }
        .alert("컨텐츠를 차단할까요?", isPresented: $showBlockAlert) {
            Button("차단", role: .destructive) {
                showBlockAlert = false
                showPopup = false
                if let selectedRoute = selectedRoute{
                    viewModelWrapper.viewModel.blockLetter(letterId: selectedRoute.id)
                }
            }
            Button("취소", role: .cancel) {
                showBlockAlert = false
            }
        } message: {
            Text("해당 비행기에서 차단하려는 경로만 사라집니다!")
        }
    }
    
    private var planeCellSection: some View {
        VStack(spacing: Spacing.sm){
            ForEach(viewModelWrapper.filteredFlights, id: \.id) { flight in
                let participantCount = viewModelWrapper.viewModel.getParticipationCount(for: flight)
                
                PlaneCell(letter: flight.routes[0], participantCount: participantCount, route: .map)
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
                    FlightMapCell(flight: flight, participantCount: participantCount,isParticipated: selectedTab == "내 항로") { route in
                        selectedRoute = route
                        showPopup = true
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedFlightId)
        }
    }
    
    private var segmentedControl: some View {
        Picker("", selection: $selectedTab){
            ForEach(segmentedMenu, id: \.self){
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, Spacing.md)
    }
    
}

#Preview {
    FlightMapView()
}

final class FlightMapViewModelWrapper: ObservableObject{
    @Published var flights: [FlightModel] = []
    @Published var filteredFlights: [FlightModel] = []//TODO: ViewModel에서 output으로 처리
    
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
    
    
    //TODO: ViewModel에서 로직 처리
    func updateFilteredFlights(selectedTab: String, searchTopic: String) {
        Task {
            let filtered = await viewModel.filterFlights(selectedTab: selectedTab, searchTopic: searchTopic)
            await MainActor.run {
                self.filteredFlights = filtered
            }
        }
    }
}



