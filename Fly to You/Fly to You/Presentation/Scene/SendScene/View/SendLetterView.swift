//
//  SendLetter.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct SendLetterView: View{
    
    @EnvironmentObject var viewModelWrapper: MainViewModelWrapper
    
    let topicData: TopicModel
    @State private var toText: String = ""
    @State private var fromText: String = ""
    @State private var message: String = ""
    
    var body: some View{
        ScrollView{
            
            ExplanationText(text: "주제에 맞는\n내용을 입력해 보세요")
            
            LetterInput(topic: topicData.topic, toText: $toText,fromText: fromText, message: $message)
        
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                
                Button(action: {
                    viewModelWrapper.viewModel.sendLetter(toText: toText, topic: topicData.topic, topicId: topicData.topicId, message: message){ result in
                        
                        switch result{
                        case .success:
                            print("[SendLetterView] - 비행기 날리기 성공")
                        case .failure(let error):
                            print(error)
                        }
                        
                    }
                }, label: {
                    HStack(spacing: 0){
                        Text("날리기")
                            .foregroundStyle(.blue1)
                        Image(systemName: "paperplane")
                    }
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
}


