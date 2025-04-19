//
//  DepartureLogViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/19/25.
//


import SwiftUI



protocol DepartureLogViewModelInput{
    func fetchLetters(fromUid: String, completion: @escaping (Result<Void, Error>) -> Void)
    func editSentLetter(letter: Letter, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol DepartureLogViewModelOutput{
    var lettersPublisher: Published<[ReceiveLetterModel]>.Publisher { get }
    var letterPublisher: Published<ReceiveLetterModel?>.Publisher { get }
}

protocol DepartureLogViewModel: DepartureLogViewModelInput, DepartureLogViewModelOutput{}


class DefaultDepartureLogViewModel: DepartureLogViewModel {
    @Published var letters: [ReceiveLetterModel] = []
    @Published var newLetter: ReceiveLetterModel?
    
    private let fetchLetterUseCase: FetchLettersUseCase
    private let editLetterUseCase: EditLetterUseCase
    
    init(useCase: FetchLettersUseCase, editLetterUseCase: EditLetterUseCase) {
        self.fetchLetterUseCase = useCase
        self.editLetterUseCase = editLetterUseCase
    }
    
    func fetchLetters(fromUid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let letterArr = try await fetchLetterUseCase.fetchSentLetters(fromUid: fromUid)
                letters = ReceiveLetter.toReceiveLetterModels(letters: letterArr)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func editSentLetter(letter: Letter, completion: @escaping (Result<Void, Error>) -> Void){
        Task {
            do {
                let letter = try await editLetterUseCase.editSentLetter(letter: letter)
                self.newLetter = ReceiveLetter.toReceiveLetterModel(letter: letter)
                
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
    var letterPublisher: Published<ReceiveLetterModel?>.Publisher {
        $newLetter
    }
}
