//
//  ProfileView.swift
//  Fly to You
//
//  Created by 최희진 on 5/11/25.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var viewModelWrapper: MainViewModelWrapper
    @Binding var visibliity: Visibility
    
    private var nickname: String {
        UserDefaults.standard.string(forKey: "nickname") ?? "알 수 없음"
    }
    
    private var isAppleLinked: Bool {
        guard let providerData = Auth.auth().currentUser?.providerData else { return false }
        return providerData.contains(where: { $0.providerID == "apple.com" })
    }
    
    var body: some View {
        VStack {
            
            Spacer().frame(height: 10)
            
            VStack(spacing: 20) {
                ProfileRow(icon: "person.fill", title: "닉네임", value: nickname, arrowIcon: true)
                    .onTapGesture {
                        viewModelWrapper.path.append(.editNickname)
                    }
                ProfileRow(icon: "applelogo", title: "소셜 연동", value: isAppleLinked ? "Apple 계정 연동됨" : "익명 계정", arrowIcon: false)
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 3)

            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .principal) {
                Text("내 프로필")
                    .foregroundStyle(.black)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                BackButton(action: {
                    viewModelWrapper.path.removeLast()
                })
            }
        }
        .onAppear {
            withAnimation {
                visibliity = .hidden
            }
        }
    }
}

struct ProfileRow: View {
    var icon: String
    var title: String
    var value: String
    var arrowIcon: Bool

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body)
                    .foregroundColor(.black)
            }

            Spacer()
            
            if arrowIcon{
                Image(.arrowRight)
                    .frame(width: 24, height: 24)
            }
        }
        .contentShape(Rectangle())
    }
}
