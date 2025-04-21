//
//  SendLetter.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct SendLetterView: View{
    
    @EnvironmentObject var viewModelWrapper: MainViewModelWrapper
    @EnvironmentObject var landingZoneViewModelWrapper: LandingZoneViewModelWrapper
    
    let topicData: TopicModel
    let route: SendLetterRoute
    let letter: Letter?
    @State private var toText: String = ""
    @State private var fromText: String = ""
    @State private var message: String = ""
    
    var body: some View{
        ScrollView{
            
            ExplanationText(text: "주제에 맞는\n내용을 입력해 보세요")
            
            PaperPlaneInput(topic: topicData.topic, toText: $toText,fromText: fromText, message: $message)
        
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                BackButton(action: {
                    if route == .start{
                        viewModelWrapper.path.removeLast()
                    } else{
                        landingZoneViewModelWrapper.path.removeLast()
                    }
                })
            }
            
            ToolbarItem(placement: .topBarTrailing){
                ToolbarFlyButton(action: {
                    sendLetter()
                })               
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    private func sendLetter(){
        if route == .start{
            viewModelWrapper.viewModel.sendLetter(toText: toText, topicData: topicData, message: message){ result in
                switch result{
                case .success:
                    print("[SendLetterView] - 비행기 날리기 성공")
                    DispatchQueue.main.async {
                        viewModelWrapper.path.append(.flyAnimation)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else{
            if let letter = self.letter{
                landingZoneViewModelWrapper.viewModel.relayLetter(toText: toText, topicData: topicData, message: message, letter: letter){ result in
                    switch result{
                    case .success:
                        print("[SendLetterView] - 비행기 이어서 날리기 성공")
                        DispatchQueue.main.async {
                            landingZoneViewModelWrapper.path.append(.flyAnimation)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

enum SendLetterRoute {
    case start
    case relay
}
