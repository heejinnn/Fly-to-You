//
//  AuthViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


protocol AuthViewModelInput{
    func signUp(nickname: String, completion: @escaping (Bool) -> Void)
}

protocol AuthViewModelOutput{
    var isLoggedInPublisher: Published<Bool>.Publisher { get }
    var duplicateErrorPublisher: Published<Bool>.Publisher { get }
}

protocol AuthViewModel: AuthViewModelInput, AuthViewModelOutput{}

class DefaultAuthViewModel: AuthViewModel {
    @Published var nickname: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var duplicateError: Bool = false
    
    private let signUpUseCae: SignUpUseCase
    
    init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCae = signUpUseCase
    }
    
    private let db = Firestore.firestore()

    func signUp(nickname: String, completion: @escaping (Bool) -> Void) {
        
        signUpUseCae.signUp(nickname: nickname){ [weak self] result in
            if result{
                self?.isLoggedIn = true
                self?.duplicateError = false
                completion(true)
            } else{
                self?.isLoggedIn = false
                self?.duplicateError = true
                completion(false)
            }
        }
    }
}

extension DefaultAuthViewModel{
    var isLoggedInPublisher: Published<Bool>.Publisher{
        $isLoggedIn
    }
    var duplicateErrorPublisher: Published<Bool>.Publisher{
        $duplicateError
    }
    
}
