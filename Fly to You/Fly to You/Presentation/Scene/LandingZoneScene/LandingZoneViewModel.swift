//
//  LandingZoneViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI
import FirebaseFirestore


protocol LandingZoneViewModelInput{
    func fetchLetters(completion: @escaping () -> Void)
}

protocol LandingZoneViewModelOutput{
    
}

protocol LandingZoneViewModel: LandingZoneViewModelInput, LandingZoneViewModelOutput{}


class DafultLandingZoneViewModel: LandingZoneViewModel {
    @Published var letters: [ReceiveLetterModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let fetchLetterUseCase: FetchLettersUseCase
    
    init(fetchLetterUseCase: FetchLettersUseCase) {
        self.fetchLetterUseCase = fetchLetterUseCase
    }

    func fetchLetters(completion: @escaping () -> Void ) {
        
    }
//    func fetchReceivedLetters() {
//        let currentUserUid = UserDefaults.standard.string(forKey: "uid") ?? ""
//        isLoading = true
//        
//        print(currentUserUid)
//        
//        // 1. 편지 먼저 불러오기
//        db.collection("letters")
//            .whereField("toUid", isEqualTo: currentUserUid)
//            .getDocuments { [weak self] (snapshot, error) in
//                guard let self = self else { return }
//                
//                if let error = error {
//                    return
//                }
//                
//                guard let docs = snapshot?.documents else { return }
//                
//                // 2. 편지 데이터 파싱 (from/to는 아직 nil)
//                var tempLetters = docs.compactMap { try? $0.data(as: ReceiveLetterModel.self) }
//                
//                // 3. 모든 관련 UID 수집 (fromUid + toUid)
//                let allUids = tempLetters.flatMap { [$0.fromUid, $0.toUid] }
//                let uniqueUids = Array(Set(allUids))
//                
//                // 4. UID들로 유저 정보 일괄 조회
//                self.fetchUsers(uids: uniqueUids) { users in
//                    // 5. 유저 정보 캐싱
//                    self.userCache = Dictionary(uniqueKeysWithValues: users.map { ($0.uid, $0) })
//                    
//                    // 6. 편지에 유저 정보 매핑
//                    for i in 0..<tempLetters.count {
//                        tempLetters[i].from = self.userCache[tempLetters[i].fromUid]
//                        tempLetters[i].to = self.userCache[tempLetters[i].toUid]
//                    }
//                    
//                    // 7. UI 업데이트
//                    DispatchQueue.main.async {
//                        self.letters = tempLetters
//                        self.isLoading = false
//                    }
//                }
//            }
//    }
//
//    // 유저 정보 일괄 조회 메서드
//    private func fetchUsers(uids: [String], completion: @escaping ([User]) -> Void) {
//        guard !uids.isEmpty else {
//            completion([])
//            return
//        }
//        
//        db.collection("user")
//            .whereField("uid", in: uids)
//            .getDocuments { (snapshot, error) in
//                if let error = error {
//                    print("유저 조회 실패: \(error)")
//                    completion([])
//                    return
//                }
//                
//                let users = snapshot?.documents.compactMap { try? $0.data(as: User.self) } ?? []
//                completion(users)
//            }
//    }
}
