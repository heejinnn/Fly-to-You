//
//  MainView.swift
//  Fly to You
//
//  Created by 최희진 on 4/12/25.
//

import SwiftUI
import Combine

struct MainView: View {
    
    @EnvironmentObject var viewModelWrapper: MainViewModelWrapper
    @State var visibility: Visibility = .automatic
    @State private var alertLimited = false
        
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        NavigationStack(path: $viewModelWrapper.path){
            ZStack {
                Image(.backgroundSky)
                    .resizable()
                
                mainContent
            }
            .edgesIgnoringSafeArea(.top)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Fly to You")
                        .font(.italiana(size: 20))
                        .foregroundStyle(.gray3)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModelWrapper.path.append(.profile)
                    }, label: {
                        Image(systemName: "person.circle")
                    })
                }
            }
            .navigationDestination(for: MainRoute.self) { route in
                switch route {
                case .profile:
                    ProfileView(visibliity: $visibility)
                case .editNickname:
                    EditNicknameView()
                case .selectSubject:
                    SelectSubjectView(visibliity: $visibility)
                case .sendLetter:
                    SendLetterView(topicData: TopicModel(topic: viewModelWrapper.topicData.topic, topicId: viewModelWrapper.topicData.topicId), route: .start, letter: nil)
                case .flyAnimation:
                    FlyAnimationView(onHome: {
                        viewModelWrapper.path = []
                    })
                }
            }
            .toolbar(visibility, for: .tabBar)
            .onAppear {
                withAnimation {
                    visibility = .visible
                }
            }
            .alert("신고 3번 이상으로 비행기 날리기가 제한됩니다.", isPresented: $alertLimited) {
                Button("확인") {
                    alertLimited = false
                }
            }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 40) {
            ShakingImage()
            
            Text("메세지를 접어서 날려보세요!")
                .font(.pretendard(.ultraLight, size: 18))
                .foregroundColor(.gray3)
            
            BottomButton(title: "비행기 날리기", action: {
                checkLimited()
            })
        }
    }
    
    private func checkLimited() {
        Task{
            do{
                let limited = try await viewModelWrapper.viewModel.fetchReportedCount()
                if limited{
                    alertLimited = true
                } else{
                    viewModelWrapper.path.append(.selectSubject)
                }
            } catch{
                Log.fault("[MainView] - checkLimited() 실패 : \(error)")
            }
        }
    }
}

#Preview {
    MainView()
}

final class MainViewModelWrapper: ObservableObject {
    @Published var path: [MainRoute] = []
    @Published var topicData: TopicModel = TopicModel(topic: "", topicId: "")
    
    var viewModel: SendLetterViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SendLetterViewModel) {
        self.viewModel = viewModel
    }
}

