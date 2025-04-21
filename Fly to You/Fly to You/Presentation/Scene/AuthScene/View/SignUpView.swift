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
        NavigationStack{
            VStack(alignment: .leading) {
                ExplanationText(text: "앱에서 사용할 \n닉네임을 입력하세요")
                
                Group{
                    HStack{
                        TextField("닉네임을 입력하세요", text: $nickname)
                            .font(.pretendard(.light, size: 15))
                            .foregroundColor(.black)
                            .padding(.leading, 15)
                        
                        Spacer()
                    }
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(!nickname.isEmpty ? .blue1 : .gray1, lineWidth: 1)
                    )
                    
                    if viewModelWrapper.duplicateError {
                        Text("이미 사용 중인 닉네임입니다.")
                            .font(.pretendard(.light, size: 13))
                            .foregroundColor(.red)
                            .padding(.top, Spacing.xxs)
                    }
                }
                .padding(.horizontal, Spacing.md)
                
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        viewModelWrapper.viewModel.signUp(nickname: nickname){ result in
                            if result{
                                appState.isLoggedIn = true
                            }
                        }
                    }, label: {
                        Text("완료")
                            .foregroundStyle(.blue1)
                    })
                    .disabled(nickname.isEmpty)
                }
            }
        }
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
