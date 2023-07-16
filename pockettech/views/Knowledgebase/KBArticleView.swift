//
//  KBArticleView.swift
//  pockettech
//
//  Created by Paul Crews on 5/29/23.
//

import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let htmlString: String

    func makeUIView(context: Context) -> WKWebView {
        print("HE \(htmlString)")
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}

struct KBArticleView: View {
    @State var tmp_article: KBArticle = KBArticle(KBID: 0, KBTimestamp: "2023", KBContext: "Text", KBProduct: "Product", KBRating_Yes: 0, KBRating_No: 0, KBRating_Views: 0, KBLastModified: "last", KBIsPrivate: false, KBStatus: 0, KBPriority: 0, KBKeywords: "keywords,general", KBAddress: "here")
    @State var article: KBArticle
    var body: some View {
        HTMLView(htmlString: article.KBContext)
    }
}

