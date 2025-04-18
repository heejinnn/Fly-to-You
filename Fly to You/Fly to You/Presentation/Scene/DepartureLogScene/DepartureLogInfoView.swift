//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//


import SwiftUI

struct DepartureLogInfoView: View{
    
    let letter: ReceiveLetterModel
    
    var body: some View{
        VStack{
            PaperPlaneCheck(letter: letter)
            
            Menu(content: {
                Button("수정하기", action: {})
                Button("삭제하기", action: {})
            }, label: {
                Image("kebabmenu")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                
                Menu(content: {
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Text("수정하기")
                            Image(systemName: "pencil")
                        }
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Group{
                                Text("삭제하기")
                                Image(systemName: "trash")
                            }
                            .foregroundStyle(.red)
                        }
                    })
                }, label: {
                    Image("kebabmenu")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
            }
        }
    }
}

#Preview {
    DepartureLogInfoView(letter: ReceiveLetterModel(id: "1", from: User(uid: "1", nickname: "nick", createdAt: Date()), to: User(uid: "1", nickname: "nick", createdAt: Date()), message: "ddd", topic: "topic", topicId: "11", timestamp: Date(), isDelivered: true, isRelayStart: true)
    )
}
