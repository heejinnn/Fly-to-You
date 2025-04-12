//
//  Fly_to_YouApp.swift
//  Fly to You
//
//  Created by 최희진 on 4/12/25.
//

import SwiftUI

@main
struct YourApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
        AppComponent()
            .makeRootView()
    }
  }
}
