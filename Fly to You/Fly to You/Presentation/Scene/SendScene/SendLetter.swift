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
    
    var body: some View{
        Text("SendLetter 뷰")
    }
}
