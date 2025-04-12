//
//  MainView.swift
//  Fly to You
//
//  Created by 최희진 on 4/12/25.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModelWrapper: MainViewModelWrapper
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    MainView(viewModelWrapper: MainViewModelWrapper())
}

final class MainViewModelWrapper: ObservableObject {
   
}
