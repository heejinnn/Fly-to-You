//
//  LetterInput.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct PaperPlaneInput: View{
    
    let topic: String
    @Binding var toText: String
    let fromText: String
    @Binding var message: String
    private let maxCharacters = 200
    
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
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text("To.")
                    .font(.gaRamYeonGgoc(size: 18))
                
                TextField(
                    "",
                    text: $toText,
                    prompt: Text("전달할 대상을 입력하세요")
                        .foregroundColor(.gray1)
                        .font(.gaRamYeonGgoc(size: 18))
                )
                .font(.gaRamYeonGgoc(size: 18))
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
                .onChange(of: message) { newValue in
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

#Preview {
    PaperPlaneInput(topic: "ddd", toText: .constant(""), fromText: "ssss", message: .constant(""))
}


