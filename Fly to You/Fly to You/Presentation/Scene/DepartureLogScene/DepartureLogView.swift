//
//  DepartureLogView.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//

import SwiftUI

struct DepartureLogView: View {
    var body: some View {
        NavigationStack {
            Text("보낸 기록 화면")
                .navigationTitle("보낸 기록")
        }
    }
}

class DepatureLogViewModelWrapper: ObservableObject {
    
}
