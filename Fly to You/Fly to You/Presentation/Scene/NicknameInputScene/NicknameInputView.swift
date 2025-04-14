//
//  NicknameInputView.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import SwiftUI

struct NicknameInputView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Text("닉네임을 입력해주세요")
                .font(.title2)
            
            TextField("닉네임", text: $viewModel.nickname)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button("시작하기") {
                viewModel.signInAnonymouslyAndSaveUser()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding()
    }
}
