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
    @State private var selectedUserID: String? = nil

    var body: some View {
        List(viewModel.userList, id: \.uid) { user in
            Button(action: {
                toUser = user
                selectedUserID = user.uid
            }) {
                HStack {
                    Text(user.nickname)
                        .foregroundColor(.primary)
                    Spacer()

                    if selectedUserID == user.uid {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue1)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
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
