//
//  ReportInput.swift
//  Fly to You
//
//  Created by 최희진 on 7/10/25.
//

import SwiftUI

struct ReportSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    let letter: ReceiveLetterModel?
    @Binding var alertDuplicatedReport: Bool
    @Binding var completeReport: Bool
    
    @State private var content = ""
    @State private var selectedType: ReportType? = nil
    @State private var showTypeDialog = false
    @StateObject private var viewModel = ReportViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xl) {
            
            Spacer()
            
            reportType
            reportContent
            
            Spacer()
            
            BottomButton(title: "제출하기", action: {
                dismiss()
                
                Task {
                    do {
                        if let letter = letter {
                            try await viewModel.sendReport(letter: letter, type: selectedType?.rawValue ?? "", content: content)
                            alertDuplicatedReport = viewModel.isDuplicated
                            completeReport = !viewModel.isDuplicated
                        }
                        Log.debug("✅ 신고 성공")
                    } catch {
                        Log.debug("🚨 신고 실패: \(error.localizedDescription)")
                    }
                }
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
                    Text(selectedType?.title ?? "신고 유형을 선택해주세요")
                        .font(.pretendard(.light, size: 15))
                        .foregroundStyle(selectedType == nil ? .gray1 : .black)
                    
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
                ForEach(ReportType.allCases, id: \.self) { type in
                    Button(type.title) {
                        selectedType = type
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.md)
    }
    
    private var reportContent: some View{
        VStack(alignment: .leading, spacing: Spacing.md){
            Text("신고 내용")
            
            TextEditor(text: $content)
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
                            if content.isEmpty {
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

enum ReportType: String, CaseIterable {
    case profanity
    case slang
    case spam
    case obscene
    case identityTheft
    case etc
    
    var title: String {
        switch self {
        case .profanity: return "욕설"
        case .slang: return "비속어"
        case .spam: return "스팸/홍보"
        case .obscene: return "음란물"
        case .identityTheft: return "타인의 개인정보 도용"
        case .etc: return "기타"
        }
    }
}
