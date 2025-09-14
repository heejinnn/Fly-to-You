//
//  SwipeAnimationView.swift
//  Fly to You
//
//  Created by 최희진 on 9/15/25.
//

import UIKit
import SwiftUI

struct SwipeAnimationView: UIViewRepresentable {
    func makeUIView(context: Context) -> SwipeAnimationUIView {
        return SwipeAnimationUIView()
    }
    
    func updateUIView(_ uiView: SwipeAnimationUIView, context: Context) {}
}

class SwipeAnimationUIView: UIView {
    
}
