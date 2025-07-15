//
//  NicknameEditView.swift
//  Fly to You
//
//  Created by 최희진 on 5/11/25.
//

import SwiftUI

struct EditNicknameView: View {
    @EnvironmentObject var viewModelWrapper: MainViewModelWrapper
    @StateObject var viewModel = EditNicknameViewModel()
    @State private var showSuccessAlert = false
    
    var body: some View {
        VStack(alignment: .leading){
            
            ExplanationText(originalText: "변경할\n닉네임을 입력하세요", boldSubstring: "닉네임")
            
            Group{
                HStack{
                    TextField("최대 10자까지 입력 가능", text: $viewModel.nickname)
                        .font(.pretendard(.light, size: 15))
                        .foregroundColor(.black)
                        .padding(.leading, 15)
                        .onChange(of: viewModel.nickname) {
                            if viewModel.nickname.count > 10 {
                                viewModel.nickname = String(viewModel.nickname.prefix(10))
                            }
                        }
                    
                    Spacer()
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(!viewModel.nickname.isEmpty ? .blue1 : .gray1, lineWidth: 1)
                )
                
                if viewModel.duplicateError {
                    Text("이미 사용 중인 닉네임입니다.")
                        .font(.pretendard(.light, size: 13))
                        .foregroundColor(.red)
                        .padding(.top, Spacing.xxs)
                }
            }
            .padding(.horizontal, Spacing.md)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                BackButton(action: {
                    viewModelWrapper.path.removeLast()
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.updateNickname{ success in
                        if success {
                            showSuccessAlert = true
                        }
                    }
                    
                }, label: {
                    Text("수정")
                        .foregroundStyle(.blue1)
                })
                .disabled(viewModel.nickname.isEmpty)
            }
        }
        .alert("닉네임이 성공적으로 변경되었어요!", isPresented: $showSuccessAlert) {
            Button("확인") {
                showSuccessAlert = false
            }
        }
    }
}


