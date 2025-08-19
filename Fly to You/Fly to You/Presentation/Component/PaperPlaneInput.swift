//
//  LetterInput.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct PaperPlaneInput: View{
    
    let topic: String
    let toText: String
    let fromText: String
    @Binding var message: String
    @Binding var showUserListSheet: Bool
    private let maxCharacters = 200
    private let sanctionText = "부적절하거나 불쾌감을 줄 수 있는 컨텐츠는\n제재를 받을 수 있습니다"
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                  Text("주제: \"\(topic)\"")
                      .font(.pretendard(.light, size: 15))
                      .foregroundColor(.white)
                      .padding(.vertical, 15)
                      .padding(.leading, 15)
                      .background(.blue1)
                  
                  Spacer()
              }
              .background(.blue1)
            
            content
            
        }
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.md)
        .shadow(radius: 3)
        
        textCount
        
        Text(sanctionText)
            .font(.pretendard(.regular, size: 10))
            .foregroundColor(.gray)
            .padding(.top, 10)
            .multilineTextAlignment(.center)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text("To.")
                    .font(.gaRamYeonGgoc(size: 18))
                
                Button(action: {
                    showUserListSheet = true
                }) {
                    HStack(spacing: Spacing.xxs) {
                        Text(toText.isEmpty ? "전달할 대상을 선택하세요" : toText)
                            .foregroundColor(toText.isEmpty ? .gray1 : .black)
                            .font(.gaRamYeonGgoc(size: 18))
                        if toText.isEmpty{
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray1)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityIdentifier(AccessibilityIdentifiers.SendLetter.toUserButton)
            }
            .padding(.top, 10)

            Text("From. \(fromText.isEmpty ? "나" : fromText)")
                .font(.gaRamYeonGgoc(size: 18))
                .foregroundColor(.black)
            
            Divider()
            
            TextEditor(text: $message)
                .frame(height: 300)
                .font(.gaRamYeonGgoc(size: 20))
                .scrollContentBackground(.hidden)
                .accessibilityIdentifier(AccessibilityIdentifiers.SendLetter.messageTextEditor)
                .overlay(
                    VStack {
                        if message.isEmpty {
                            Text("여기에 메시지를 입력하세요")
                                .foregroundColor(.gray1)
                                .font(.gaRamYeonGgoc(size: 20))
                                .padding(.top, 6)
                                .padding(.leading, Spacing.xxs)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                    }
                )
                .onChange(of: message) { _, newValue in
                    if message.count > maxCharacters {
                        message = String(message.prefix(maxCharacters))
                    }
                }
        }
        .padding(.horizontal, 15)
        .padding(.top, 5)
        .background{
            Image(.backgroundPaper)
                .resizable()
        }
    }
    
    private var textCount: some View{
        // 하단 글자 수 카운터
        HStack {
            Spacer()
            Text("\(message.count)/\(maxCharacters)")
                .font(.pretendard(.regular, size: 12))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, Spacing.md)
    }
}

//#Preview {
//    PaperPlaneInput(topic: "ddd", toText: .constant(""), fromText: "ssss", message: .constant(""))
//}


