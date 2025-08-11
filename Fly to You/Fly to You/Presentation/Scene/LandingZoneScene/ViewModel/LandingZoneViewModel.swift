//
//  LandingZoneViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI
import FirebaseFirestore


protocol LandingZoneViewModelInput{
    func relayLetter(toUid: String, topicData: TopicModel, message: String, letter: Letter, completion: @escaping (Result<Void, Error>) -> Void)
    func observeLetters()
    func removeLettersListener()
    func fetchReportedCount() async throws -> Bool
    func blockLetter(letterId: String)
}

protocol LandingZoneViewModelOutput{
    var lettersPublisher: Published<[ReceiveLetterModel]>.Publisher { get }
}

protocol LandingZoneViewModel: LandingZoneViewModelInput, LandingZoneViewModelOutput{}


class DafultLandingZoneViewModel: LandingZoneViewModel {
    @Published var letters: [ReceiveLetterModel] = []
    private let fetchLetterUseCase: FetchLettersUseCase
    private let relayLetterUseCase: RelayLetterUseCase
    private let blockLetterUseCase: BlockLetterUseCase
    
    init(fetchLetterUseCase: FetchLettersUseCase, relayLetterUseCase: RelayLetterUseCase, blockLetterUseCase: BlockLetterUseCase) {
        self.fetchLetterUseCase = fetchLetterUseCase
        self.relayLetterUseCase = relayLetterUseCase
        self.blockLetterUseCase = blockLetterUseCase
    }

    func relayLetter(toUid: String, topicData: TopicModel, message: String, letter: Letter, completion: @escaping (Result<Void, Error>) -> Void){
        Task {
            do {
                let _ = try await relayLetterUseCase.send(toUid: toUid, topic: topicData.topic, topicId: topicData.topicId, message: message, previousLetter: letter)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func observeLetters() {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        fetchLetterUseCase.observeReceivedLetters(toUid: uid) { [weak self] letters in
            self?.letters = letters
        }
    }
    
    func removeLettersListener() {
        fetchLetterUseCase.removeListeners()
    }
 
    func fetchReportedCount() async throws -> Bool{
        try await relayLetterUseCase.fetchReportedCount()
    }
    
    func blockLetter(letterId: String){
        Task {
            try await blockLetterUseCase.blockLetter(letterId: letterId)
            removeLettersListener()
            observeLetters()
        }
    }
}

extension DafultLandingZoneViewModel{
    var lettersPublisher: Published<[ReceiveLetterModel]>.Publisher{
        $letters
    }
}
