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
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 40) {
            ShakingImage()
            
            Text("메세지를 접어서 날려보세요!")
                .font(.pretendard(.ultraLight, size: 18))
                .foregroundColor(.gray3)
            
            BottomButton(title: "비행기 날리기", action: {
                viewModelWrapper.path.append(.selectSubject)
            })
        }
    }
}

struct ShakingImage: View {
    @State private var isShaking = false

    var body: some View {
        Image(.paperplane)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
            .rotationEffect(.degrees(isShaking ? 5 : -5)) // 좌우로 흔들기
            .animation(
                Animation.easeInOut(duration: 1)
                    .repeatForever(autoreverses: true),
                value: isShaking
            )
            .onAppear {
                isShaking = true
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

enum MainRoute {
    case profile
    case editNickname
    case selectSubject
    case sendLetter
    case flyAnimation
}
