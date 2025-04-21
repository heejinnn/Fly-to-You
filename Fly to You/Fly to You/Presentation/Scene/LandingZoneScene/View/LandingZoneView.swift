//
//  LandingZoneView.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import SwiftUI
import Combine

struct LandingZoneView: View {
    
    @EnvironmentObject var viewModelWrapper: LandingZoneViewModelWrapper
    
    var body: some View {
        NavigationStack(path: $viewModelWrapper.path) {
            VStack{
                Spacer().frame(height: Spacing.lg)
                
                Text("도착한 종이 비행기들이 여기에 착륙해요")
                    .font(.pretendard(.medium, size: 15))
                    .foregroundStyle(.gray3)
                
                Spacer().frame(height: Spacing.lg)
                
                VStack(spacing: Spacing.xs){
                    ForEach(viewModelWrapper.letters, id: \.id){ letter in
                        PlaneCell(letter: letter, route: .receive)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModelWrapper.letter = letter
                                viewModelWrapper.path.append(.landingZoneInfo)
                            }
                    }
                }
                Spacer()
            }
            .navigationDestination(for: LandingZoneRoute.self) { route in
                switch route {
                case .landingZoneInfo:
                    if let letter = viewModelWrapper.letter {
                        LandingZoneInfoView(letter: letter)
                    }
                case .relayLetter:
                    if let topic = viewModelWrapper.topic, let letter = viewModelWrapper.letter {
                        SendLetterView(topicData: topic, route: .relay, letter: letter.toLetter(data: letter))
                    }
                case .flyAnimation:
                    FlyAnimationView(onHome: {
                        fetchLetters()
                        viewModelWrapper.path = []
                    })
                }
            }
        }
        .onAppear{
            fetchLetters()
        }
    }
    private func fetchLetters(){
        viewModelWrapper.viewModel.fetchLetters{ result in
            switch result {
            case .success:
                print("[LandingZoneView] - 받은 비행기 가져오기 성공")
            case .failure:
                print("[LandingZoneView] - 받은 비행기 가져오기 실패")
            }
        }
    }
}

final class LandingZoneViewModelWrapper: ObservableObject {
    @Published var path: [LandingZoneRoute] = []
    @Published var letter: ReceiveLetterModel? = nil
    @Published var topic: TopicModel? = nil
    @Published var letters: [ReceiveLetterModel] = []
    
    var viewModel: LandingZoneViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: LandingZoneViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        viewModel.lettersPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.letters, on: self)
            .store(in: &cancellables)
    }
}

enum LandingZoneRoute {
    case landingZoneInfo
    case relayLetter
    case flyAnimation
}
