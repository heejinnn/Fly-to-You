//
//  DepartureLogView.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//

import SwiftUI
import Combine

struct DepartureLogView: View {
    
    @EnvironmentObject var viewModelWrapper: DepatureLogViewModelWrapper
    private let currentUid = UserDefaults.standard.string(forKey: "uid") ?? ""
     
    var body: some View {
        NavigationStack(path: $viewModelWrapper.path) {
            VStack{
                Spacer().frame(height: Spacing.lg)
                
                Text("내가 보낸 종이 비행기들을 확인할 수 있어요🧐")
                    .font(.pretendard(.medium, size: 15))
                    .foregroundStyle(.gray3)
                
                Spacer().frame(height: Spacing.lg)
                
                VStack{
                    ForEach(viewModelWrapper.letters, id: \.id){ letter in
                        PlaneCell(letter: letter, route: .send)
                            .onTapGesture {
                                viewModelWrapper.letter = letter
                                viewModelWrapper.path.append(.departureLogInfo)
                            }
                    }
                }
                Spacer()
            }
            .navigationDestination(for: DepartureLogRoute.self, destination: { route in
                switch route{
                    case .departureLogInfo:
                    if let letter = viewModelWrapper.letter {
                        DepartureLogInfoView(letter: letter)
                    }
                }
            })
        }
        .onAppear{
            viewModelWrapper.viewModel.fetchLetters(fromUid: currentUid){ result in
                switch result {
                case .success():
                    print("[DepartureLogView] - 보낸 기록 조회 성공")
                case .failure(_):
                    print("[DepartureLogView] - 보낸 기록 조회 실패")
                }
                
            }
        }
    }
}

class DepatureLogViewModelWrapper: ObservableObject {
    @Published var path: [DepartureLogRoute] = []
    @Published var letter: ReceiveLetterModel? = nil
    @Published var letters: [ReceiveLetterModel] = []
    
    var viewModel: DepartureLogViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DepartureLogViewModel){
        self.viewModel = viewModel
        bind()
    }
    
    func bind(){
        viewModel.lettersPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.letters, on: self)
            .store(in: &cancellables)
        
        viewModel.letterPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.letter, on: self)
            .store(in: &cancellables)
    }
}

#Preview {
    DepartureLogView()
}

enum DepartureLogRoute {
    case departureLogInfo
}
