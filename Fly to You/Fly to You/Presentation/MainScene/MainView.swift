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
        ZStack {
            Image("background_sky")
                .resizable()
                .ignoresSafeArea(edges: .top)
            
            VStack {
                Text("홈 뷰 내용")
            }
            
        }
    }
}

#Preview {
    MainView(viewModelWrapper: MainViewModelWrapper())
}

final class MainViewModelWrapper: ObservableObject {
   
}
