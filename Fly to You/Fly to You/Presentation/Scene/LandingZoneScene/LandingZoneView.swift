//
//  LandingZoneView.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import SwiftUI

struct LandingZoneView: View {
    
    @StateObject var viewModelWrapper = LandingZoneViewModelWrapper()
    @StateObject var viewModel = LandingZoneViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModelWrapper.path) {
            
            VStack{
                Spacer().frame(height: Spacing.lg)
                
                Text("도착한 종이 비행기들이 여기에 착륙해요")
                    .font(.pretendard(.medium, size: 15))
                    .foregroundStyle(.gray3)
                
                Spacer().frame(height: Spacing.lg)
                
                VStack(spacing: Spacing.xs){
                    ForEach(viewModel.letters, id: \.id){ letter in
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
            viewModel.fetchReceivedLetters()
        }
    }
}

final class LandingZoneViewModelWrapper: ObservableObject {
    @Published var path: [LandingZoneRoute] = []
    @Published var letter: ReceiveLetterModel? = nil
}

enum LandingZoneRoute {
    case landingZoneInfo
}
