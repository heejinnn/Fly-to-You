//
//  NicknameInputView.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import SwiftUI
import Combine

struct NicknameInputView: View {
//    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("닉네임", text: $viewModel.nickname)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            if viewModel.nicknameDuplicateError {
                Text("이미 사용 중인 닉네임입니다.")
                    .foregroundColor(.red)
            }
            
            Button("시작하기") {
                viewModel.trySignUp()
            }
            .disabled(viewModel.nickname.isEmpty)
        }
        .padding()
    }
}

final class AuthViewModelWrapper: ObservableObject {
    @Published var isLoggedIn: Bool
    @Published var duplicateError: Bool
    
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
