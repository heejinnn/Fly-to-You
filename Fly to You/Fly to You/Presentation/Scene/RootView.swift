//
//  RootView.swift
//  Fly to You
//
//  Created by 최희진 on 4/14/25.
//

import SwiftUI
import FirebaseAuth



struct RootView: View {

    var body: some View {
        if let user = Auth.auth().currentUser {
            MainTabView()
        } else {
            AppComponent()
                .makeSignUpView()
        }
    }
}

