//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct SelectSubject: View {
    
    @EnvironmentObject var viewModelWrapper: MainViewModelWrapper
    @State private var selectedTopic: String = ""
    @State private var customTopic: String = ""
    
    var body: some View {
        VStack {
            Text("주제를 선택하거나 입력하세요")
            
            ForEach(["응원 한마디", "오늘 가장 행복했던 순간은?", "오늘의 TMI", "칭찬 한마디"], id: \.self) { topic in
                
                Button(action: {
                    
                }, label: {
                    Text(topic)
                })
            }
            TextField("직접 입력", text: $customTopic)
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    viewModelWrapper.path.append(.sendLetter)
                }, label: {
                    Text("다음")
                })
            }
        }
    }
}
