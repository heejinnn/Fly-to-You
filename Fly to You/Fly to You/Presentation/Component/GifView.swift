//
//  GifView.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//

import SwiftUI
import WebKit

import SwiftUI
import WebKit

struct GifView: UIViewRepresentable {
    let gifName: String
    var onLoadCompleted: (() -> Void)? = nil

    func makeCoordinator() -> Coordinator {
        Coordinator(onLoadCompleted: onLoadCompleted)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let path = Bundle.main.path(forResource: gifName, ofType: "gif") else { return }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        let base64 = data?.base64EncodedString() ?? ""
        let html = """
        <html>
        <body style="margin:0; padding:0; background:transparent;">
            <img src="data:image/gif;base64,\(base64)" style="width:100%; height:100%;" />
        </body>
        </html>
        """
        uiView.loadHTMLString(html, baseURL: nil)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let onLoadCompleted: (() -> Void)?

        init(onLoadCompleted: (() -> Void)?) {
            self.onLoadCompleted = onLoadCompleted
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            onLoadCompleted?()
        }
    }
}
