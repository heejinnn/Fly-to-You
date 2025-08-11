//
//  DefaultLetterRepo.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import FirebaseFirestore
import FirebaseAuth

final class DefaultLetterRepo: LetterRepo {
    private let db = Firestore.firestore()
    private var receivedListener: ListenerRegistration?
    private var sentListener: ListenerRegistration?
    
    func save(letter: Letter) async throws -> Letter {
        let document = db.collection("letters").document(letter.id)
        try await document.setData(letter.toFirestoreData())
        return letter
    }
    
    func updateIsDelivered(letterId: String, isDelivered: Bool) async throws {
        let document = db.collection("letters").document(letterId)
        try await document.updateData([
            "isDelivered": isDelivered
        ])
    }
    
    func editSentLetter(letter: Letter) async throws -> ReceiveLetterDto {
        let letterRef = db.collection("letters").document(letter.id)
        let document = try await letterRef.getDocument()
        let newLetter = letter.toFirestoreData()

        if document.exists {
            try await letterRef.updateData(newLetter)
        }
        return letter.toReceiveLetterDto(data: letter)
    }
    
    func deleteSentLetter(letter: Letter) async throws {
        let letterRef = db.collection("letters").document(letter.id)
        try await letterRef.delete()
    }
    
    func observeReceivedLetters(toUid: String, onUpdate: @escaping ([ReceiveLetterDto]) -> Void) {
        // 기존 리스너 해제 (중복 방지)
        receivedListener?.remove()
        
        receivedListener = db.collection("letters")
            .whereField("toUid", isEqualTo: toUid)
            .whereField("isDelivered", isEqualTo: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    onUpdate([])
                    return
                }
                let dtos = documents.compactMap { try? $0.data(as: ReceiveLetterDto.self) }
                onUpdate(dtos)
            }
    }
    
    func observeSentLetters(fromUid: String, onUpdate: @escaping ([ReceiveLetterDto]) -> Void) {
        sentListener?.remove()
        sentListener = db.collection("letters")
            .whereField("fromUid", isEqualTo: fromUid)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    onUpdate([])
                    return
                }
                let dtos = documents.compactMap { try? $0.data(as: ReceiveLetterDto.self) }
                onUpdate(dtos)
            }
    }
    
    func removeListeners() {
        receivedListener?.remove()
        sentListener?.remove()
        receivedListener = nil
        sentListener = nil
    }
    
    func blockLetter(letterId: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        try await db.collection("users").document(currentUid).updateData([
            "blockedLetters": FieldValue.arrayUnion([letterId])
        ])
    }
    
    func getBlockedLetters() async throws -> [String] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return []}
        
        let document = try await db.collection("users").document(currentUid).getDocument()
        return document.data()?["blockedLetters"] as? [String] ?? []
    }
}
