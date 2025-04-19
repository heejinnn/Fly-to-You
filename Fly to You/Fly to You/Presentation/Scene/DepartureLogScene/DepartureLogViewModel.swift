//
//  DepartureLogViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/19/25.
//


import SwiftUI



protocol DepartureLogViewModelInput{
    func fetchLetters(fromUid: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol DepartureLogViewModelOutput{
    var lettersPublisher: Published<[ReceiveLetterModel]>.Publisher { get }
}

protocol DepartureLogViewModel: DepartureLogViewModelInput, DepartureLogViewModelOutput{}


class DefaultDepartureLogViewModel: DepartureLogViewModel {
    @Published var letters: [ReceiveLetterModel] = []
    
    private let useCase: FetchLettersUseCase
    
    init(useCase: FetchLettersUseCase) {
        self.useCase = useCase
    }
    
    func fetchLetters(fromUid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let letterArr = try await useCase.fetchSentLetters(fromUid: fromUid)
                letters = ReceiveLetter.toReceiveLetterModels(letters: letterArr)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

extension DefaultDepartureLogViewModel{
    var lettersPublisher: Published<[ReceiveLetterModel]>.Publisher {
        $letters
    }
}
