//
//  MainView.swift
//  Fly to You
//
//  Created by 최희진 on 4/12/25.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModelWrapper: MainViewModelWrapper
    
    var body: some View {
        NavigationStack(path: $viewModelWrapper.path){
            ZStack {
                Image("background_sky")
                    .resizable()
                    .ignoresSafeArea(edges: .top)
                
                mainContent
            }
            .edgesIgnoringSafeArea(.top)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Fly to You")
                        .font(.italiana(size: 20))
                        .foregroundStyle(.gray3)
                }
            }
            .navigationDestination(for: MainRoute.self) { route in
                switch route {
                case .selectSubject:
                    SelectSubjectView()
                case .sendLetter:
                    SendLetterView(topic: viewModelWrapper.topic)
                }
            }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 40) {
            Image("paperplane")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
            Text("메세지를 접어서 날려보세요!")
                .font(.pretendard(.ultraLight, size: 18))
                .foregroundColor(.gray3)
            
            Button(action: {
                viewModelWrapper.path.append(.selectSubject)
            }, label: {
                Text("비행기 날리기")
                    .font(.pretendard(.ultraLight, size: 18))
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue1)
                    .cornerRadius(10)
            })
            .padding(.horizontal, 20)
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    MainView()
}

final class MainViewModelWrapper: ObservableObject {
    @Published var path: [MainRoute] = []
    @Published var topic: String = ""

}

enum MainRoute: Hashable {
    case selectSubject
    case sendLetter
}
