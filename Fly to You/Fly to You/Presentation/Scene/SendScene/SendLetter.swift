//
//  SendLetter.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct SendLetter: View{
    
    var topic: String = "응원 한마디"
    @State private var toText: String = ""
    @State private var fromText: String = ""
    @State private var message: String = ""
    
    let maxCharacters = 100
    
    @StateObject private var viewModel = SendLetterViewModel()
    
    var body: some View{
        VStack{
            
            ExplanationCell(text: "주제에 맞는\n내용을 입력해 보세요")
            
            VStack(spacing: 0) {
                // 상단 주제 영역
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
                
                // 종이 스타일 영역
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack{
                        Text("To.")
                            .font(.system(size: 18))
                        TextField("전달할 대상을 입력하세요", text: $toText)
                            .font(.system(size: 18))
                    }
                    .padding(.top, 10)
     
                    Text("From. \(fromText.isEmpty ? "나" : fromText)")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    
                    Divider()
                    
                    TextEditor(text: $message)
                        .frame(height: 300)
                        .font(.system(size: 14))
                        .background(Color.clear)
                        .overlay(
                            VStack {
                                if message.isEmpty {
                                    Text("여기에 메시지를 입력하세요")
                                        .foregroundColor(.gray1)
//                                        .padding(.top, 6)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Spacer()
                            }
                        )
                }
                .padding(.horizontal, 15)
                .padding(.top, 5)
                .background(.white)
            }
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .shadow(radius: 3)
            
            // 하단 글자 수 카운터
            HStack {
                Spacer()
                Text("\(message.count)/\(maxCharacters)")
                    .font(.pretendard(.regular, size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Text("날리기􀈟")
            }
        }
        
        
    }
}

#Preview {
    SendLetter()
}
