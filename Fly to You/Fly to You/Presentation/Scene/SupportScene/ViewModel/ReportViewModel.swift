//
//  ReportViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 7/10/25.
//

import Foundation
import FirebaseFirestore

final class ReportViewModel: ObservableObject {

    private let db = Firestore.firestore()
    
    func sendReport(letter: ReceiveLetterModel, type: String, content: String) throws{
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        
        let report = Report(id: UUID().uuidString, reporterId: uid, type: type, content: content, letterId: letter.id, createdAt: Date())
           
        try db.collection("Reports")
            .document(report.id)
            .setData(from: report) { error in
                if let error = error {
                    Log.error("[ReportViewModel] - 신고 저장 실패: \(error.localizedDescription)")
                } else {
                    Log.info("[ReportViewModel] - 신고 성공적으로 저장됨 \(report)")
                }
            }
    }
}
