//
//  NicknameEditView.swift
//  Fly to You
//
//  Created by 최희진 on 5/11/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

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

final class EditNicknameViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var duplicateError: Bool = false

    private let db = Firestore.firestore()

    func updateNickname(completion: @escaping (Bool) -> Void) {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        checkNicknameDuplicate(nickname: trimmed) { [weak self] isDuplicate in
            guard let self = self else { return }

            if isDuplicate {
                self.duplicateError = true
                return
            }

            guard let uid = Auth.auth().currentUser?.uid else { return }

            db.collection("users").document(uid).updateData([
                "nickname": trimmed
            ]) { error in
                if let error = error {
                    print("닉네임 업데이트 실패: \(error)")
                    return
                }

                UserDefaults.standard.set(trimmed, forKey: "nickname")
                self.duplicateError = false
                completion(true)
            }
        }
        completion(false)
    }

    private func checkNicknameDuplicate(nickname: String, completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .whereField("nickname", isEqualTo: nickname)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("중복 검사 오류: \(error.localizedDescription)")
                    completion(true)
                    return
                }
                let isDuplicated = snapshot?.documents.isEmpty == false
                completion(isDuplicated)
            }
    }
}
