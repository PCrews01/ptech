//
//  GSheets.swift
//  pockettech
//
//  Created by Paul Crews on 6/9/23.
//

import SwiftUI
import GoogleSignIn

struct ranger: Codable, Hashable{
    let majorDimension: String
    var values: [[String]]
}
struct GSheets: View {
    @State var cbooks: [ranges] = []
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                print("ready")
                Task{
                    await sendSheet()
                }
            }
    }
    
    func sendSheet() async{
        let url = URL(string: putsy)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(tk)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let values = [["A","B","C","D"]]
        let t = ranger(majorDimension: "ROWS", values: values)
            let encoder = JSONEncoder()
        let new_cel_cal = t
        do {
            request.httpBody = try encoder.encode(t)
        } catch {
            print("88")
        }
        do{
            let data = try encoder.encode(new_cel_cal)
            print("dt \(t)")
            let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
            print("res \(request.httpBody)")
            print("ret \(response)")
        }catch{
            print("rer")
        }
            // etc...
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



struct GSheets_Previews: PreviewProvider {
    static var previews: some View {
        GSheets()
    }
}
