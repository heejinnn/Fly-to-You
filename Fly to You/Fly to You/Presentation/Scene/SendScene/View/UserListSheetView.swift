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
    @State private var searchUserId: String = ""
    private var filteredUserList: [User] {
        if searchUserId.isEmpty {
            return viewModel.userList
        } else {
            return viewModel.userList.filter {
                $0.nickname.localizedCaseInsensitiveContains(searchUserId)
            }
        }
    }

    var body: some View {
        VStack{
            
            Spacer().frame(height: Spacing.sm)
            
            SearchBar(seachText: $searchUserId, searchBarRoute: .searchNickname)
                .padding(Spacing.md)
            
            List(filteredUserList, id: \.uid) { user in
                Button(action: {
                    toUser = user
                }) {
                    HStack {
                        Text(user.nickname)
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if toUser?.uid == user.uid {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue1)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityIdentifier(AccessibilityIdentifiers.SendLetter.userListButton)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            Task {
                do {
                    _ = try await viewModel.fetchUserList()
                    Log.info("[UserListSheetView] - user list 가져오기 성공")
                } catch {
                    Log.warning("[UserListSheetView] - user list 가져오기 실패")
                }
            }
        }
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
        
        DispatchQueue.main.async { [weak self] in
            self?.userList = userDatas
        }
    }
}
