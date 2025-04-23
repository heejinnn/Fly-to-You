//
//  LandingZoneViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI
import FirebaseFirestore


protocol LandingZoneViewModelInput{
    func fetchLetters(completion: @escaping (Result<Void, Error>) -> Void)
    func relayLetter(toUid: String, topicData: TopicModel, message: String, letter: Letter, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol LandingZoneViewModelOutput{
    var lettersPublisher: Published<[ReceiveLetterModel]>.Publisher { get }
}

protocol LandingZoneViewModel: LandingZoneViewModelInput, LandingZoneViewModelOutput{}


class DafultLandingZoneViewModel: LandingZoneViewModel {
    @Published var letters: [ReceiveLetterModel] = []
    private let fetchLetterUseCase: FetchLettersUseCase
    private let relayLetterUseCase: RelayLetterUseCase
    
    init(fetchLetterUseCase: FetchLettersUseCase, relayLetterUseCase: RelayLetterUseCase) {
        self.fetchLetterUseCase = fetchLetterUseCase
        self.relayLetterUseCase = relayLetterUseCase
    }

    func fetchLetters(completion: @escaping (Result<Void, Error>) -> Void  ) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        Task {
            do {
                let letterArr = try await fetchLetterUseCase.fetchReceivedLetters(toUid: uid)
                letters = ReceiveLetter.toReceiveLetterModels(letters: letterArr)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
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
}

extension DafultLandingZoneViewModel{
    var lettersPublisher: Published<[ReceiveLetterModel]>.Publisher{
        $letters
    }
}
