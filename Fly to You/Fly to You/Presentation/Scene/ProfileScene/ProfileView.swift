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
        VStack(spacing: Spacing.xxl) {
            
            VStack(spacing: Spacing.xs) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray0)
                
                Text(nickname)
                    .font(.pretendard(.medium, size: 20))
                    .foregroundColor(.black)
            }
            
            VStack(spacing: Spacing.md) {
                ProfileRow(icon: "person.fill", title: "닉네임 변경", arrowIcon: true)
                    .onTapGesture {
                        viewModelWrapper.path.append(.editNickname)
                    }
                
                Divider()
                
                ProfileRow(icon: "envelope.fill", title: "문의하기", arrowIcon: false)
                
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 1)

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
    var arrowIcon: Bool

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.blue1)
 
            Text(title)
                .font(.pretendard(.medium, size: 15))
                .foregroundColor(.black)
            
            Spacer()
            
            if arrowIcon{
                Image(.arrowRight)
                    .frame(width: 24, height: 24)
            }
        }
        .contentShape(Rectangle())
    }
}
