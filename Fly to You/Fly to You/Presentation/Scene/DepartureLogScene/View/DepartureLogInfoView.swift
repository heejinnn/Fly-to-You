//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//


import SwiftUI

struct DepartureLogInfoView: View{
    
    @EnvironmentObject var viewModelWrapper: DepatureLogViewModelWrapper
    @State var letter: ReceiveLetterModel
    @State private var isEditMode: Bool = false
    @State private var showAlert: Bool = false
    @State private var toUser: User? = nil
    @State private var fromText: String = ""
    @State private var message: String = ""
    @State private var isLoading: Bool = false
    @State private var showUserListSheet = false // 시트 상태
    
    init(letter: ReceiveLetterModel) {
        self._letter = State(initialValue: letter)
        self._toUser = State(initialValue: letter.to)
        self._message = State(initialValue: letter.message)
    }
    
    var body: some View{
        ZStack{
            
            VStack{
                if letter.isDelivered{
                    ExplanationText(originalText: "비행기를\n새로 날려보세요", boldSubstring: "새로 날려보세요")
                } else{
                    ExplanationText(originalText: "날아간 비행기를\n수정할 수 있어요", boldSubstring: "수정할 수 있어요")
                }
                
                if !isEditMode{
                    PaperPlaneCheck(letter: letter)
                } else{
                    PaperPlaneInput(topic: letter.topic, toText: toUser?.nickname ?? "", fromText: fromText, message: $message, showUserListSheet: $showUserListSheet)
                }
                
                Spacer().frame(height: 40)
                
                if letter.isDelivered{
                    Text("릴레이가 진행중이므로\n수정이나 삭제는 불가능합니다")
                        .font(.pretendard(.regular, size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray3)
                }
                
                Spacer()
            }
            
            if isLoading {
                ProgressView()
                    .controlSize(.regular)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                leadingToolbarButton
            }
            ToolbarItem(placement: .topBarTrailing) {
                if !letter.isDelivered{
                    trailingToolbarButton
                }
            }
        }
        .alert("비행기를 삭제할까요?", isPresented: $showAlert) {
            Button("삭제", role: .destructive) {
                viewModelWrapper.viewModel.deleteSentLetter(letter: letter.toLetter(data: letter)){ result in
                    switch result {
                    case .success():
                        DispatchQueue.main.async {
                            viewModelWrapper.path.removeLast()
                        }
                        print("[DepartureLogInfoView] - 삭제 성공")
                    case .failure(_):
                        print("[DepartureLogInfoView] - 삭제 실패")
                    }
                }
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("보낸 기록이 사라져요 🥲")
        }
        .sheet(isPresented: $showUserListSheet) {
            UserListSheetView(toUser: $toUser)
                .presentationDetents([.medium, .large])
        }
    }
    
    private var leadingToolbarButton: some View {
        Group {
            if isEditMode {
                Button(action: {
                    isEditMode = false
                    self.fromText = letter.from.nickname
                    self.message = letter.message
                }) {
                    Text("취소")
                        .foregroundStyle(.gray3)
                }
            } else {
                BackButton(action: {
                    viewModelWrapper.path.removeLast()
                })
            }
        }
    }
    
    private var trailingToolbarButton: some View {
        Group {
            if isEditMode {
                Button(action: {

                    if let toUser, !message.isEmpty {
                        isEditMode = false
                        isLoading = true
                        
                        let newLetter = ReceiveLetterModel(
                            id: letter.id,
                            from: letter.from,
                            to: toUser,
                            message: message,
                            topic: letter.topic,
                            topicId: letter.topicId,
                            timestamp: letter.timestamp,
                            isDelivered: letter.isDelivered,
                            isRelayStart: letter.isRelayStart)
                        
                        viewModelWrapper.viewModel.editSentLetter(letter: newLetter, toUid: toUser.uid){
                            result in
                            switch result {
                            case .success(let data):
                                letter = data
                                print(letter)
                                isLoading = false
                                print("[DepartureLogInfoView] - 수정 성공")
                            case .failure(_):
                                print("[DepartureLogInfoView] - 수정 실패")
                            }
                        }
                    }
                }) {
                    Text("저장")
                        .foregroundStyle(.blue1)
                }
            } else {
                menuButton
            }
        }
    }
    
    private var menuButton: some View {
        Menu {
            Button(action: { isEditMode = true }) {
                HStack {
                    Text("수정하기")
                    Image(systemName: "pencil")
                }
            }
            Button(role: .destructive, action: {
                showAlert = true
            }) {
                HStack {
                    Text("삭제하기")
                    Image(systemName: "trash")
                }
            }
        } label: {
            Image(.kebabmenu)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
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
