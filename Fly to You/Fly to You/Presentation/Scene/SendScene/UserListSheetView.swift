//
//  UserListSheetView.swift
//  Fly to You
//
//  Created by 최희진 on 4/23/25.
//


import SwiftUI

struct UserListSheetView: View {
    @StateObject var viewModel = UserListSheetViewModel()
    @Binding var toUser: User?
    @State private var selectedUserId: String? = nil
    @State private var seachUserId: String = ""
    private var filteredUserList: [User] {
        if seachUserId.isEmpty {
            return viewModel.userList
        } else {
            return viewModel.userList.filter {
                $0.nickname.localizedCaseInsensitiveContains(seachUserId)
            }
        }
    }

    var body: some View {
        VStack{
            
            Spacer().frame(height: Spacing.sm)
            
            searchBar
            
            List(filteredUserList, id: \.uid) { user in
                Button(action: {
                    toUser = user
                    selectedUserId = user.uid
                }) {
                    HStack {
                        Text(user.nickname)
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if selectedUserId == user.uid {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue1)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            Task {
                do {
                    _ = try await viewModel.fetchUserList()
                    print("성공")
                } catch {
                    print("실패")
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack{
            TextField("닉네임을 검색해 보세요", text: $seachUserId)
                .font(.pretendard(.light, size: 15))
                .foregroundColor(.black)
                .padding(.leading, 15)

            Spacer()
            
            Button(action: {
                
            }, label: {
                Image(systemName: "magnifyingglass")
                    .frame(width: 25, height: 25)
                    .padding(.trailing, 15)
                    .foregroundStyle(.gray1)
            })
        }
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(.gray1, lineWidth: 1)
        )
        .padding(Spacing.md)
    }
}


import FirebaseFirestore

final class UserListSheetViewModel: ObservableObject {
    
    @Published var userList: [User] = []
    private let db = Firestore.firestore()
    
    func fetchUserList() async throws{
        let snapshot = try await db.collection("users")
               .whereField("uid", isNotEqualTo: UserDefaults.standard.string(forKey: "uid") ?? "")
               .getDocuments()
        
        let userDatas: [User] = snapshot.documents.compactMap {
            try? $0.data(as: User.self)
        }
        DispatchQueue.main.async {
            self.userList = userDatas
        }
    }
}
