//
//  GifView.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//


import SwiftUI
import Gifu

struct GifView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> GIFImageView {
        let imageView = GIFImageView()
        imageView.animate(withGIFNamed: gifName)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: GIFImageView, context: Context) {
    }
}
