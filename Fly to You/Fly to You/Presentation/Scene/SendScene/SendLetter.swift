//
//  SendLetter.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct SendLetter: View{
    
    @State private var selectedUserUID: String = ""
    @State private var users: [User] = []
    
    @StateObject private var viewModel = SendLetterViewModel()
    
    var body: some View{
        Text("SendLetter 뷰")
        Button(action: {
            
            viewModel.sendLetter(toUID: "n6F34VvWgvVdm8FHtaK4", topic: "저녁 메뉴 추천", message: "삼겹살"){ _ in
                
            }
            
        }, label: {
            Text("보내기")
        })
    }
}
