//
//  LetterInfoView.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI

struct LandingZoneInfoView: View{
    
    @EnvironmentObject var viewModelWrapper: LandingZoneViewModelWrapper
    let letter: ReceiveLetterModel
    
    var body: some View{
        VStack{
            ExplanationText(originalText: "비행기를\n이어서 날려보세요", boldSubstring: "이어서 날려보세요")
            
            PaperPlaneCheck(letter: letter)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                BackButton(action: {
                    viewModelWrapper.path.removeLast()
                })
            }
            ToolbarItem(placement: .topBarTrailing){
                ToolbarFlyButton(action: {
                    viewModelWrapper.topic = TopicModel(topic: letter.topic, topicId: letter.topicId)
                    viewModelWrapper.path.append(.relayLetter)
                })
            }
        }
    }
}
