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
    @State private var showReportModal: Bool = false
    @State private var showBlockAlert: Bool = false
    @State private var alertDuplicatedReport: Bool = false
    @State private var completeReport: Bool = false
    @State private var alertLimited: Bool = false
    
    var body: some View{
        VStack{
            ExplanationText(originalText: "비행기를\n이어서 날려보세요", boldSubstring: "이어서 날려보세요")
            
            PaperPlaneCheck(letter: letter, showReportIcon: true, showReportModal: $showReportModal, showBlockAlert: $showBlockAlert)
            
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
                    checkLimited()
                })
            }
        }
        .sheet(isPresented: $showReportModal) {
            ReportSheetView(letter: letter, alertDuplicatedReport: $alertDuplicatedReport, completeReport: $completeReport)
                .presentationDragIndicator(.visible)
        }
        .alert("신고가 접수되었습니다. 검토까지는 최대 24시간 소요됩니다!", isPresented: $completeReport) {
            Button("확인") {
                completeReport = false
            }
        }
        .alert("이미 신고된 편지예요. 빠르게 검토 중입니다!", isPresented: $alertDuplicatedReport) {
            Button("확인") {
                alertDuplicatedReport = false
            }
        }
        .alert("신고 3번 이상으로 비행기 날리기가 제한됩니다.", isPresented: $alertLimited) {
            Button("확인") {
                alertLimited = false
            }
        }
    }
    
    private func checkLimited(){
        Task{
            do{
                let limited = try await viewModelWrapper.viewModel.fetchReportedCount()
                
                if limited{
                    alertLimited = true
                } else{
                    viewModelWrapper.topic = TopicModel(topic: letter.topic, topicId: letter.topicId)
                    viewModelWrapper.path.append(.relayLetter)
                }
            }
            catch{
                Log.fault("[LandingZoneInfoView] - checkLimited() 실패 : \(error)")
            }
        }
    }
}
