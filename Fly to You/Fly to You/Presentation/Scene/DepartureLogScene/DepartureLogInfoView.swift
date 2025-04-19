//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//


import SwiftUI

struct DepartureLogInfoView: View{
    
    @EnvironmentObject var viewModelWrapper: DepatureLogViewModelWrapper
    let letter: ReceiveLetterModel
    @State private var isEditMode: Bool = false
    
    var body: some View{
        VStack{
            ExplanationText(text: "비행기를\n새로 날려보세요")
            
            PaperPlaneCheck(letter: letter)
            
            Spacer().frame(height: 40)
            
            if letter.isDelivered{
                Text("릴레이가 진행중이므로\n수정이나 삭제는 불가능합니다")
                    .font(.pretendard(.regular, size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray3)
            }
            
            Spacer()
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
    }
    
    private var leadingToolbarButton: some View {
        Group {
            if isEditMode {
                Button(action: { isEditMode = false }) {
                    Text("취소")
                        .foregroundStyle(.gray3)
                }
            } else {
                Button(action: {
                    viewModelWrapper.path.removeLast()
                }) {
                    Image("arrow_left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
    
    private var trailingToolbarButton: some View {
        Group {
            if isEditMode {
                Button(action: { isEditMode = false }) {
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
                // 삭제 액션 구현
            }) {
                HStack {
                    Text("삭제하기")
                    Image(systemName: "trash")
                }
            }
        } label: {
            Image("kebabmenu")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    DepartureLogInfoView(letter: ReceiveLetterModel(id: "1", from: User(uid: "1", nickname: "nick", createdAt: Date()), to: User(uid: "1", nickname: "nick", createdAt: Date()), message: "ddd", topic: "topic", topicId: "11", timestamp: Date(), isDelivered: true, isRelayStart: true)
    )
}
