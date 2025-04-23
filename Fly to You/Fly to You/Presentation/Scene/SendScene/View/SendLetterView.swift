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
    @State private var toUser: User? = nil
    @State private var fromText: String = ""
    @State private var message: String = ""
    @State private var showUserListSheet = false // 시트 상태
    
    var body: some View{
        ScrollView{
            
            ExplanationText(originalText: "주제에 맞는\n내용을 입력해 보세요", boldSubstring: "주제에 맞는")
            
            PaperPlaneInput(topic: topicData.topic, toText: toUser?.nickname ?? "", fromText: fromText, message: $message, showUserListSheet: $showUserListSheet)
        
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
                    if toUser == nil, !message.isEmpty{
                        sendLetter()
                    }
                })
            }
        }
        .sheet(isPresented: $showUserListSheet) {
            UserListSheetView(toUser: $toUser)
                .presentationDetents([.medium, .large])
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

