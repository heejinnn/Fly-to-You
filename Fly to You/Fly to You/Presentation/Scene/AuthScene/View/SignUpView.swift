//
//  NicknameInputView.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import SwiftUI
import Combine

struct SignUpView: View {
    @ObservedObject var viewModelWrapper: AuthViewModelWrapper
    @EnvironmentObject var appState: AppState
    @State private var nickname = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("닉네임", text: $nickname)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            if viewModelWrapper.duplicateError {
                Text("이미 사용 중인 닉네임입니다.")
                    .foregroundColor(.red)
            }
            
            Button("시작하기") {
                viewModelWrapper.viewModel.signUp(nickname: nickname){ result in
                    if result{
                        appState.isLoggedIn = true
                    }
                }
            }
            .disabled(nickname.isEmpty)
        }
        .padding()
    }
}

final class AuthViewModelWrapper: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var duplicateError: Bool = false
    
    var viewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        bind()
    }
    private func bind() {
        viewModel.isLoggedInPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoggedIn, on: self)
            .store(in: &cancellables)
        
        viewModel.duplicateErrorPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.duplicateError, on: self)
            .store(in: &cancellables)
    }
}
