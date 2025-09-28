//
//  AuthViewModel.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import Foundation

protocol AuthViewModelInput{
    func signUp(nickname: String, completion: @escaping (Bool) -> Void)
}

protocol AuthViewModelOutput{
    var isLoggedIn: Bool { get }
    var duplicateError: Bool { get }
}

protocol AuthViewModel: AuthViewModelInput, AuthViewModelOutput{}

@Observable
final class DefaultAuthViewModel: AuthViewModel {
    private(set) var isLoggedIn: Bool = false
    private(set) var duplicateError: Bool = false
    
    private let signUpUseCae: SignUpUseCase
    
    init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCae = signUpUseCase
    }

    func signUp(nickname: String, completion: @escaping (Bool) -> Void) {
        
        signUpUseCae.signUp(nickname: nickname){ [weak self] result in
            if result{
                self?.isLoggedIn = true
                self?.duplicateError = false
            } else{
                self?.isLoggedIn = false
                self?.duplicateError = true
            }
            completion(result)
        }
    }
}
