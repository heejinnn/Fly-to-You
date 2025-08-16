//
//  SignUpView.swift
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
    
    @State private var isEULAAccepted = false
    @State private var showingEULA = false
    @State private var isClickedSignUpButton = false
    
    private var isFormValid: Bool {
        !nickname.isEmpty && isEULAAccepted
    }
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                ExplanationText(originalText: "앱에서 사용할 \n닉네임을 입력하세요", boldSubstring: "닉네임")
                
                Group{
                    HStack{
                        TextField("최대 10자까지 입력 가능", text: $nickname)
                            .font(.pretendard(.light, size: 16))
                            .foregroundColor(.black)
                            .padding(.leading, Spacing.md)
                            .onChange(of: nickname) {
                                if nickname.count > 10 {
                                    nickname = String(nickname.prefix(10))
                                }
                            }
                        
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModelWrapper.viewModel.signUp(nickname: nickname) { result in
                            if result {
                                Log.info("[SignUpView] - 회원가입 성공")
                                appState.isLoggedIn = true
                            }
                        }
                    }, label: {
                        Text("완료")
                            .foregroundStyle(isFormValid ? .blue1 : .gray1)
                    })
                    .disabled(!isFormValid)
                }
            }
        }
        .sheet(isPresented: $showingEULA) {
            EULADetailView()
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
