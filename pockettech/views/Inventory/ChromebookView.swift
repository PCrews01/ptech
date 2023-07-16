//
//  ChromebookView.swift
//  pockettech
//
//  Created by Paul Crews on 6/7/23.
//

import SwiftUI

struct InventoryItem{
    let ID: Int
    let OSIS: String
    let email:String
    let serial:String
    let first:String
    let last:String
    let full_name:String
    let cohort:Int
    let requested: String?
}
struct ranges: Codable, Hashable{
    let majorDimension: String
    var values: [[String]]
    let range: String
}

struct rev:Codable{
    let spreadsheetid: String
    let valueRanges: [ranges]
}
struct ChromebookView: View {
    @State var cbooks: [ranges] = []
    let id_cell = 0
    let osis_cell = 1
    let computer_number_cell = 2
    let hotspot_cell = 3
    let email_cell = 4
    let chromebook_serial_cell = 5
    let first_name_cell = 6
    let last_name_cell = 7
    let full_name_cell = 8
    let cohort_cell = 9
    let requested_cell = 10
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var show_sheet = false
    @State var inventory_object: InventoryItem?
    @State var id_filter = ""
    @State var bg_color = Color.gray.opacity(0.4)
    @State var card_font_color = Color.black
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                TextField("Search By ID", text: $id_filter)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(.regularMaterial)
                    .onChange(of: id_filter) { newValue in
                        if id_filter.count >= 3 {
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
                Button {
                    print("search")
                } label: {
                    Text("Search")
                }

            }
            .padding(.horizontal, 10)
            .onAppear {
                    Task{
                        await getSheet()
                    }
                }
            ScrollView{

                LazyVGrid(columns: columns) {

                    ForEach(cbooks, id:\.self){ book in
                        ForEach(book.values, id:\.self) { bk in
                            if id_filter.count < 1 || bk[id_cell].contains(id_filter) {
                                NavigationLink(destination: ItemDetailsView(inventory_item: InventoryItem(ID: Int(bk[id_cell]) ?? 0003, OSIS: bk[osis_cell], email: bk[email_cell], serial: bk[chromebook_serial_cell], first: bk[first_name_cell], last: bk[last_name_cell], full_name: bk[full_name_cell], cohort: Int(bk[cohort_cell]) ?? 0001, requested: bk[requested_cell]))) {
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(bg_color)
                                        VStack(alignment: .leading){
                                            Text(bk[id_cell])
                                                .font(.title)
                                                .fontWeight(.bold)
                                            Text(bk[chromebook_serial_cell])
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                            Spacer()
                                            
                                            Text(bk[full_name_cell])
                                            Text(bk[email_cell])
                                            
                                        }.padding()
                                    }
                                }
                                .frame(minHeight: 100)
                            }
                            }
                        }
                    }
                }.navigationBarTitle(Text("Student Chromebooks"))
            }
        }
    
    func getSheet() async{
        guard let url = URL(string: inventory_json_url) else {
            return
        }
            let d =  URLSession.shared.dataTask(with:url){
                data, response, error in
                if let err = error {
                    print(" there's been an error \(err)")
                    return
                }
                if let data = data{
                    do{
                        var json_data = try JSONDecoder().decode(ranges.self, from: data)
                        json_data.values.removeFirst()
                        let n = json_data
                        cbooks.append(n)
                    } catch let e as NSError {
                        print("There's been an error \(e)")
                    }
                }
                
            }
        d.resume()
    }
}

struct ChromebookView_Previews: PreviewProvider {
    static var previews: some View {
        ChromebookView( inventory_object: InventoryItem(ID: 0000, OSIS: "0000", email: "me@me.com", serial: "123ABC", first: "John", last: "Doe", full_name: "John Doe", cohort: 2024, requested: "8800"))
    }
}
