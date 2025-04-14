//
//  SignUpUseCase.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

protocol SignUpUseCase{
    func signUp(nickname: String, completion: @escaping (Bool) -> Void)
}

class DefaultSignUpUseCase: SignUpUseCase{
    private let repository: SignUpRepo
    
    init(repository: SignUpRepo) {
        self.repository = repository
    }
    
    func signUp(nickname: String, completion: @escaping (Bool) -> Void) {
        repository.signUp(nickname: nickname, completion: completion)
    }
}
