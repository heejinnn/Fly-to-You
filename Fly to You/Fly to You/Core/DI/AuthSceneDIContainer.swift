//
//  SignUpSceneDIContainer.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

final class AuthSceneDIContainer {
    // MARK: - Factory

    func makeSignUpFactory() -> DefaultAuthFactory { // DefaultMainFactory를 생성하여 반환
        let viewModelWrapper = makeAuthViewModelWrapper()
        return DefaultAuthFactory(authViewModelWrapper: viewModelWrapper)
    }

    // MARK: - Use Cases
    
    private func makeSignUpUseCase() -> SignUpUseCase {
        let repository = makeSignUpRepo()
        return DefaultSignUpUseCase(repository: repository)
    }

    // MARK: - Repository
    
    func makeSignUpRepo() -> SignUpRepo {
        return DefaultSignUpRepo()
    }

    // MARK: - View Model
    
    func makeAuthViewModel() -> AuthViewModel {
        let useCase = makeSignUpUseCase()
        
        return DefaultAuthViewModel(signUpUseCase: useCase)
    }

    // MARK: - View Model Wrapper

    func makeAuthViewModelWrapper() -> AuthViewModelWrapper {
        AuthViewModelWrapper(viewModel: makeAuthViewModel())
    }
}
