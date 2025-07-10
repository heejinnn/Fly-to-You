//
//  ReportInput.swift
//  Fly to You
//
//  Created by 최희진 on 7/10/25.
//

import SwiftUI

struct ReportSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var message = ""
    @State private var type = ""
    @State private var showTypeDialog = false
    
    var reportTypes: [String] = ["욕설", "비속어", "스팸/홍보", "음란물", "타인의 개인정보 도용", "기타"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xl) {
            
            Spacer()
            
            reportType
            reportContent
            
            Spacer()
            
            BottomButton(title: "제출하기", action: {
                dismiss()
            })
        }
    }
    
    private var reportType: some View{
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("신고 유형")
            
            Button(action: {
                showTypeDialog = true
            }, label: {
                HStack {
                    Text(type.isEmpty ? "신고 유형을 선택해주세요" : type)
                        .font(.pretendard(.light, size: 15))
                        .foregroundStyle(type.isEmpty ? .gray1 : .black)
                    
                    Spacer()
                    
                    Image(.arrowDown)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Spacing.md)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(.gray1, lineWidth: 1)
                )
            })
            .buttonStyle(.plain)
            .confirmationDialog("신고 유형을 선택해주세요", isPresented: $showTypeDialog, titleVisibility: .visible) {
                ForEach(reportTypes, id: \.self) { report in
                    Button(report) {
                        type = report
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.md)
    }
    
    private var reportContent: some View{
        VStack(alignment: .leading, spacing: Spacing.md){
            Text("신고 내용")
            
            TextEditor(text: $message)
                .frame(height: 200)
                .padding(.top, 9)
                .padding(.leading, 11)
                .font(.pretendard(.light, size: 15))
                .scrollContentBackground(.hidden)
                .overlay(
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(.gray1, lineWidth: 1)
                        
                        VStack {
                            if message.isEmpty {
                                Text("예) 폭력적인 말이 포함되어있습니다.")
                                    .foregroundColor(.gray1)
                                    .font(.pretendard(.light, size: 15))
                                    .padding(Spacing.md)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer()
                        }
                    }
                )
        }
        .padding(.horizontal, Spacing.md)
    }
}
