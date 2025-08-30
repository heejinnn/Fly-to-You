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
                            .accessibilityIdentifier(AccessibilityIdentifiers.SignUp.nicknameTextField)
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
                            .accessibilityIdentifier(AccessibilityIdentifiers.SignUp.duplicateErrorText)
                    }
                }
                .padding(.horizontal, Spacing.md)
                
                eulaCheckBox
                
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
                    .accessibilityIdentifier(AccessibilityIdentifiers.SignUp.completeButton)
                }
            }
        }
        .sheet(isPresented: $showingEULA) {
            EULADetailSheetView()
        }
    }
    
    private var eulaCheckBox: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.sm) {
                Button(action: {
                    isEULAAccepted.toggle()
                }) {
                    Image(systemName: isEULAAccepted ? "checkmark.square.fill" : "square")
                        .foregroundColor(isEULAAccepted ? .blue1 : .gray1)
                        .frame(width: 20, height: 20)
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.SignUp.eulaCheckbox)
                
                HStack(spacing: Spacing.xxs) {
                    Text("사용권 계약에 동의합니다.")
                        .font(.pretendard(.regular, size: 14))
                    
                    Text("(필수)")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button("보기") {
                        showingEULA = true
                    }
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(.blue1)
                    .accessibilityIdentifier(AccessibilityIdentifiers.SignUp.eulaDetailButton)
                }
            }
            .padding(.horizontal, Spacing.md)
        }
        .padding(.top, Spacing.xs)
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
