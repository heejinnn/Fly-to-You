//
//  DepartureLogViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/19/25.
//


import SwiftUI



protocol DepartureLogViewModelInput{
    func fetchLetters(fromUid: String, completion: @escaping (Result<Void, Error>) -> Void)
    func editSentLetter(letter: ReceiveLetterModel, toUid: String, completion: @escaping (Result<ReceiveLetterModel, Error>) -> Void)
    func deleteSentLetter(letter: Letter, completion: @escaping (Result<Void, Error>) -> Void)
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
    private let deleteLetterUseCase: DeleteLetterUseCase
    
    init(fetchLetterUseCase: FetchLettersUseCase, editLetterUseCase: EditLetterUseCase, deleteLetterUseCase: DeleteLetterUseCase) {
        self.fetchLetterUseCase = fetchLetterUseCase
        self.editLetterUseCase = editLetterUseCase
        self.deleteLetterUseCase = deleteLetterUseCase
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
    
    func editSentLetter(letter: ReceiveLetterModel, toUid: String, completion: @escaping (Result<ReceiveLetterModel, Error>) -> Void){
        Task {
            do {
                let letter = try await editLetterUseCase.editSentLetter(letter: letter.toLetter(data: letter), toUid: toUid)
                let newLetter = ReceiveLetter.toReceiveLetterModel(letter: letter)
                
                // letters에 저장된 letter 중 newLetter과 id가 같으면 변경
                if let index = letters.firstIndex(where: { $0.id == newLetter.id }) {
                    letters[index] = newLetter
                }
                
                completion(.success(newLetter))
            } catch {
                completion(.failure(error))
            }
        }
    }
    func deleteSentLetter(letter: Letter, completion: @escaping (Result<Void, Error>) -> Void){
        Task{
            do{
                try await deleteLetterUseCase.deleteSentLetter(letter: letter)
                
                if let index = letters.firstIndex(where: { $0.id == letter.id }) {
                    letters.remove(at: index)
                }
                
                completion(.success(()))
            } catch{
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
