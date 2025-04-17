//
//  LandingZoneViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI
import FirebaseFirestore


protocol LandingZoneViewModelInput{
    func fetchLetters(completion: @escaping (Result<Void, Error>) -> Void )
}

protocol LandingZoneViewModelOutput{
    var lettersPublisher: Published<[ReceiveLetterModel]>.Publisher { get }
}

protocol LandingZoneViewModel: LandingZoneViewModelInput, LandingZoneViewModelOutput{}


class DafultLandingZoneViewModel: LandingZoneViewModel {
    @Published var letters: [ReceiveLetterModel] = []
    private let fetchLetterUseCase: FetchLettersUseCase
    
    init(fetchLetterUseCase: FetchLettersUseCase) {
        self.fetchLetterUseCase = fetchLetterUseCase
    }

    func fetchLetters(completion: @escaping (Result<Void, Error>) -> Void  ) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        
        Task {
            do {
                let letterArr = try await fetchLetterUseCase.execute(toUid: uid)
                letters = ReceiveLetter.toReceiveLetterModels(letters: letterArr)
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
