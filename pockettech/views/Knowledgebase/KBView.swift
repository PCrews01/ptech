//
//  KBView.swift
//  pockettech
//
//  Created by Paul Crews on 5/25/23.
//

import SwiftUI
import WebKit
struct KB {
    let images: [String]
    let text: String
    
    
}
struct KBView: View {
    @State var articles: [KBArticle] = []
    @State var animation_amount: CGFloat = 0
    @State var keywords:[String] = []
    @State var kb_filter = ""
    @State var bg_color = Color.gray.opacity(0.45)
    @State var card_font_color = Color.white
    var body: some View {
        VStack{
            Spacer()
            HStack{
                TextField("Search By Title", text: $kb_filter)
                    .padding()
                    .background(.regularMaterial)
                    .onChange(of: kb_filter) { newValue in
                        if kb_filter.count >= 3 {
                            withAnimation(.linear(duration: 0.8)) {
                                bg_color = Color("light_green")
                                card_font_color = Color(.white)
                            }
                        } else {
                            withAnimation(.linear(duration: 0.8)){
                                card_font_color = Color.black
                                bg_color = Color.gray.opacity(0.45)
                            }
                        }
                    }
                if kb_filter.count > 2 {
                    Button {
                        kb_filter = ""
                    } label: {
                        Text("Clear")
                    }
                }
            }
            .onAppear {
                fetchArticles()
            }
            
            ScrollView(showsIndicators: true){
                LazyVGrid(columns: getDeviceOrientation() == "Landscape" ? gridColumns(columns: 4) : gridColumns(columns: 2)){
                    
                    ForEach(articles, id:\.self) { kb in
                        if kb_filter.count < 1 || kb.KBProduct.contains(kb_filter) {
                            NavigationLink {
                                KBArticleView(article: kb)
                            } label: {
                                ZStack(alignment:.center){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("light_green"))
                                    
                                    NavigationLink {
                                        KBArticleView(article: kb)
                                    } label: {
                                        VStack(alignment: .leading){
                                            Spacer()
                                            Text("\(kb.KBProduct)")
                                                .fontWeight(.semibold)
                                                .padding(.bottom, 5)
                                            Spacer()
                                            
                                        }
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .navigationTitle("Knowledgebase")
                            }
                        }
                    }
                }
            }
        }
    }
    private func fetchArticles() {
       guard let url = URL(string: "https://app.atera.com/api/v3/knowledgebases") else {
           print("Invalid URL")
           return
       }
       
       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       request.addValue("application/json", forHTTPHeaderField: "Accept")
       request.addValue("7c215afdf2a346df8469ba88dc909771", forHTTPHeaderField: "X-API-KEY")
       
       URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               print("Error: \(error.localizedDescription)")
               return
           }
           
           guard let datab = data else {
               print("No data received")
               return
           }
           
           do {
               let skr = String(data: datab, encoding: .utf8)
               guard let jsonData = skr!.data(using: .utf8) else {
                   print("Failed to convert JSON string to data.")
                   return
               }
               let decoder = JSONDecoder()
               do {
                   let response = try decoder.decode(KnowledgeBase.self, from: jsonData)
                    articles = response.items
                   
                   
               } catch {
                   print("Failed to decode JSON data: \(error)")
               }
           }
           
       }.resume()
   }
    func keywordArray(keywords: String) -> [String]{
        let key_array = keywords.split(separator: ",")
        var keyword_array: [String] = []
        key_array.map { kw in
            keyword_array.append(String(kw))
        }
        
        return keyword_array
    }
}
struct KBView_Previews: PreviewProvider {
    static var previews: some View {
        KBView()
    }
}
