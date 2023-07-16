//
//  AlertView.swift
//  pockettech
//
//  Created by Paul Crews on 6/10/23.
//

import SwiftUI

struct AlertView: View {
    @Binding var alert: AteraAlert
    @State var alert_update:String = ""
    @Binding var show_sheet : Bool 
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Picker("Mark", selection: $alert_update) {
                    Text("Ackowledge")
                        .tag("acknowledge")
                    Text("Resolved")
                        .tag("resolved")
                    Text("Mark")
                        .tag("")
                }.tag("picker")
                    .onChange(of: alert_update) { newValue in
                        if newValue == "acknowledge"{
                            print("Deleting...")
                            updateAlert(id: alert.AlertID)
                        } else{
                            print("New \(newValue)")
                        }
                    }
            }
        }
        Spacer()
        VStack(alignment: .leading, spacing: 5){
            Text(alert.Title)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.bottom, 5)
            HStack{
                Text("Alert ID")
                Spacer()
                Text("\(alert.AlertID)")
            }
            HStack{
                Text("Device")
                Spacer()
                Text(alert.DeviceName)
            }
            HStack{
                Text("Severity")
                Spacer()
                Text(alert.Severity)
            }
            HStack{
                Text("Date Created")
                Spacer()
                Text(alert.Created)
            }
            HStack{
                Text("Customer Name")
                Spacer()
                Text(alert.CustomerName)
            }
            Text("Alert Message:")
                
        }
        ScrollView{
            Text(alert.AlertMessage)
                .multilineTextAlignment(.leading)
        }
    }
    func updateAlert(id: Int){
        guard let url = URL(string: "https://app.atera.com/api/v3/alerts/\(id)") else {
            print("Invalid URL")
            return
        }
        print("running delete")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("7c215afdf2a346df8469ba88dc909771", forHTTPHeaderField: "X-API-KEY")
        print(request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("Data \(data)")
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            show_sheet = false
            print("Deleted Alert \(response)")
        }.resume() 
    }
}

//struct AlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertView()
//    }
//}
