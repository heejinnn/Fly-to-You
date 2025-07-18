//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct SelectSubjectView: View {
    
    @EnvironmentObject var viewModelWrapper: MainViewModelWrapper
    @State private var selectedTopic: String = ""
    @State private var customTopic: String = ""
    @Binding var visibliity: Visibility
    
    private let topicList = ["응원 한마디", "오늘 가장 행복했던 순간은?", "오늘의 TMI", "칭찬 한마디", "최근에 본 영화 추천"]
    
    var body: some View {
        VStack {
            
            ExplanationText(originalText: "마음에 드는\n주제를 선택하세요", boldSubstring: "주제")
            
            ForEach(topicList, id: \.self) { topic in
                Button(action: {
                    selectedTopic = topic
                    customTopic = ""
                }) {
                    SubjectCell(text: topic, isSelected: selectedTopic == topic)
                }
            }
            .onChange(of: customTopic) { oldValue, newValue in
                if !newValue.isEmpty {
                    selectedTopic = ""
                }
            }
            
            inputSubject
                .padding(.horizontal, Spacing.md)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                BackButton(action: {
                    viewModelWrapper.path.removeLast()
                })
            }
            
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    viewModelWrapper.topicData.topic = selectedTopic.isEmpty ? customTopic : selectedTopic
                    viewModelWrapper.topicData.topicId = UUID().uuidString
                    if !viewModelWrapper.topicData.topic.isEmpty{
                        viewModelWrapper.path.append(.sendLetter)
                    }
                }, label: {
                    Text("다음")
                        .foregroundStyle(.blue1)
                })
            }
        }
        .onAppear {
            withAnimation {
                visibliity = .hidden
            }
        }
    }
    
    private var inputSubject: some View{
        HStack{
            TextField("직접 입력", text: $customTopic)
                .font(.pretendard(.light, size: 15))
                .foregroundColor(.black)
                .padding(.leading, 15)

            Spacer()
        }
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(!customTopic.isEmpty ? .blue1 : .gray1, lineWidth: 1)
        )
    }
}


