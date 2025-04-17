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
                        PlaneCell(letter: letter)
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
                        LetterInfoView(letter: letter)
                    } else {
                        Text("편지 정보가 없습니다.")
                    }
                }
            }
        }
        .onAppear{
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
}

final class LandingZoneViewModelWrapper: ObservableObject {
    @Published var path: [LandingZoneRoute] = []
    @Published var letter: ReceiveLetterModel? = nil
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
}
