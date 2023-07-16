//
//  ItemDetailsView.swift
//  pockettech
//
//  Created by Paul Crews on 6/8/23.
//

import SwiftUI

struct ItemDetailsView: View {
    @State var inventory_item: InventoryItem
    @State var replacement_reason: String = ""
    @State var repair_reason: String = ""
    @State var form_to_display: String = ""
    @State var form_height: CGFloat = 0
    @State var form_width: CGFloat = 0
    @State var serial_tag: String = ""
    @State var detail_opacity: Double = 1
    @State var cohort_to_year = DateComponents()
    
    
    var body: some View {
        VStack(alignment:.leading){
            Text(inventory_item.full_name)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(inventory_item.email)
                .font(.title2)
                .fontWeight(.semibold)
            Divider()
            if form_width >= 300 {
                Text("New \(form_to_display == "replacement" ? "Replacement" : "Repair")")
                    .font(.title)
                    .fontWeight(.semibold)
                if form_to_display == "replacement"{
                    HStack{
                        Spacer()
                        TextField("New Serial/Asset Tag", text: $serial_tag)
                            .frame(minWidth:form_width, minHeight: 25, alignment: .topLeading)
                            .padding()
                            .border(.bar, width: 2)
                        Spacer()
                    }
                }
                HStack{
                    Spacer()
                    TextField(form_to_display == "replacement" ? "Reason for replacement?" : "Reason for repair", text: form_to_display == "replacement" ? $replacement_reason : $repair_reason)
                        .frame(minWidth:form_width, minHeight: form_height, alignment: .topLeading)
                        .padding()
                        .border(.bar, width: 2)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .cornerRadius(5)
                    Spacer()
                }.padding(.top, 10)
                
                
                if replacement_reason.count >= 6 {
                    HStack{
                        Spacer()
                        Button {
                            print("Got it")
                        } label: {
                            Text("Submit")
                        }
                        .foregroundColor(Color.white)
                        .fontWeight(.semibold)
                        .frame(width: 150, height: 25)
                        .padding(3)
                        .background(Color("AccentColor"))
                        .cornerRadius(5)
                        Spacer()
                    }
                }
            } else {
                VStack{
                    HStack{
                        Text("Serial Number")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(inventory_item.serial)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .lineLimit(1)
                    .padding(.vertical, 5)
                    Divider()
                    HStack{
                        Text("ID")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(cohortToYear(cohort:inventory_item.ID))")
                    }
                    .lineLimit(1)
                    .padding(.vertical, 5)
                    Divider()
                    HStack{
                        Text("OSIS Number")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(inventory_item.OSIS)
                    }
                    .lineLimit(1)
                    .padding(.vertical, 5)
                    Divider()
                    HStack{
                        Text("Cohort")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(cohortToYear(cohort:inventory_item.cohort))")
                    }
                    .lineLimit(1)
                    .padding(.vertical, 5)
                    Divider()
                }
                .opacity(detail_opacity)
            }
            Spacer()
            
//            ACTION BUTTONS
            HStack{
                Button {
                    withAnimation(.linear(duration: 0.8)) {
                        form_height = form_to_display != "replacement" ? 350 : form_height >= 350 ? 0 : 350
                        form_width = form_to_display != "replacement" ? 350 : form_width >= 350 ? 0 : 350
                    }
                    withAnimation(.linear(duration: form_width > 0 ? 0.4 : 1.6)){
                        detail_opacity = form_width > 0 ? 0 : 1
                    }
                    form_to_display = form_to_display == "replacement" ? "" : "replacement"
                } label: {
                    Text(form_to_display == "replacement" ? "Close" : "Replacement")
                }
                .frame(width: 100)
                .padding()
                .foregroundColor(.white)
                .background(form_to_display == "replacement" ? .red : Color("AccentColor"))
                .cornerRadius(10)
                Spacer()
                Button {
                    withAnimation(.linear(duration: 0.8)) {
                        form_height = form_to_display != "repair" ? 350 : form_height >= 350 ? 0 : 350
                        form_width = form_to_display != "repair" ? 350 : form_width >= 350 ? 0 : 350
                    }
                    withAnimation(.linear(duration: form_width > 0 ? 0.4 : 1.6)){
                        detail_opacity = form_width > 0 ? 0 : 1
                    }
                    form_to_display =  form_to_display == "repair" ? "" : "repair"
                } label: {
                    Text(form_to_display == "repair" ? "Close" : "Repair")
                }
                .frame(width: 100)
                .padding()
                .foregroundColor(.white)
                .background(form_to_display == "repair" ? .red : Color("light_green"))
                .cornerRadius(10)
            }
            .padding()
        }.padding()
    }
    func cohortToYear(cohort: Int) -> String {
        var st = String(cohort)
        return st.replacingOccurrences(of: ",", with: "")
    }
}

struct ItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailsView(inventory_item: InventoryItem(ID: 000, OSIS: "9100", email: "us@me.com", serial: "987xyz", first: "Johnathan", last: "Doeman", full_name: "Johnathan Doeman", cohort: 2022, requested: "8801"))
    }
}
