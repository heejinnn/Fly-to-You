//
//  ReportViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 7/10/25.
//

import Foundation
import FirebaseFirestore

final class ReportViewModel: ObservableObject {

    @Published var isDuplicated = false
    private let db = Firestore.firestore()
    
    func sendReport(letter: ReceiveLetterModel, type: String, content: String) async throws{
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        
        let report = Report(id: UUID().uuidString, reporterId: uid, reportedId: letter.from.uid, type: type, content: content, letterId: letter.id, createdAt: Date())
        try await checkDuplicatedReport(letterId: letter.id, uid: uid)
        
        guard !isDuplicated else {
            Log.info("[ReportViewModel] - 신고는 이미 존재함")
            return
        }
        
        do {
            try db.collection("reports")
                .document(report.id)
                .setData(from: report)
            
            try await addReportedCount(uid: letter.from.uid)
            
            Log.info("[ReportViewModel] - 신고 성공적으로 저장됨 \(report)")
        } catch {
            Log.error("[ReportViewModel] - 신고 저장 실패: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func checkDuplicatedReport(letterId: String, uid: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            db.collection("reports")
                .whereField("letterId", isEqualTo: letterId)
                .whereField("reporterId", isEqualTo: uid)
                .getDocuments { [weak self] snapshot, error in
                    guard let self = self else {
                        continuation.resume()
                        return
                    }

                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    } else{
                        let duplicated = snapshot?.documents.isEmpty == false
                        self.isDuplicated = duplicated
                        Log.info("[ReportViewModel] - 신고 중복 처리 \(letterId)")
                        
                        continuation.resume()
                    }
                }
        }
    }
    
    private func addReportedCount(uid: String) async throws {
        let userRef = db.collection("users").document(uid)
        let document = try await userRef.getDocument()
        
        if document.exists {
            try await userRef.updateData([
                "reportedCount": FieldValue.increment(Int64(1))
            ])
        }
    }
}
