//
//  funcs.swift
//  pockettech
//
//  Created by Paul Crews on 5/27/23.
//

import Foundation
import SwiftUI

 var items : [Any] = []
//var my_open_tickets = UserDefaults.standard.data(forKey: "Tickets")
var my_open_tickets: [Ticket] = []
var my_open_articles: [KBArticle] = []
var sheets_url = "https://sheets.googleapis.com/v4/spreadsheets/18pNtZHXhSuxMcHwKvfAHat9wOQ-bls2LPhGCQTv3X3o/values:batchGet?majorDimension=COLUMNS&ranges=A1%3AK12&valueRenderOption=FORMATTED_VALUE&key=AIzaSyDFZO_3jtWjMiXLtHOqggQt6ZNo9hKTqe0"
var sheet_json = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRkFc8--geYZyw1xzMjEPbxaF8QNGzvItowXjdd9N08O46Ah64KPTD767Bf54ceUM0AVPfFJX9pyPDd/pubhtml"

var sheet_json_url = "https://sheets.googleapis.com/v4/spreadsheets/1H1j-jo39_jMpMbzHn0XDLI3hTyEK5Soj_gTJTD9HJts/values/Sheet1?alt=json&key=AIzaSyDFZO_3jtWjMiXLtHOqggQt6ZNo9hKTqe0&majorDimension=ROWS"
var in_js = "https://sheets.googleapis.com/v4/spreadsheets/1eeEqF-tYX8hBLfAG9zeoE11BIfMGHGN9lnuqgR4AzXw/values/Picked%20Up?alt=json&key=AIzaSyDFZO_3jtWjMiXLtHOqggQt6ZNo9hKTqe0&"
var inventory_json_url = "https://sheets.googleapis.com/v4/spreadsheets/1eeEqF-tYX8hBLfAG9zeoE11BIfMGHGN9lnuqgR4AzXw/values/Picked%20Up?alt=json&key=AIzaSyDFZO_3jtWjMiXLtHOqggQt6ZNo9hKTqe0"
var inventory_json_urls = "https://sheets.googleapis.com/v4/spreadsheets/1eeEqF-tYX8hBLfAG9zeoE11BIfMGHGN9lnuqgR4AzXw/values/A1/Picked%20Up?alt=json&key=AIzaSyDFZO_3jtWjMiXLtHOqggQt6ZNo9hKTqe0"
var sheet_id = "1eeEqF-tYX8hBLfAG9zeoE11BIfMGHGN9lnuqgR4AzXw"
var sheet_full = "1eeEqF-tYX8hBLfAG9zeoE11BIfMGHGN9lnuqgR4AzXw/values/Picked%20Up?alt=json&key=AIzaSyDFZO_3jtWjMiXLtHOqggQt6ZNo9hKTqe0"

var tk = "AIzaSyDFZO_3jtWjMiXLtHOqggQt6ZNo9hKTqe0"

var putsy = "https://sheets.googleapis.com/v4/spreadsheets/1eeEqF-tYX8hBLfAG9zeoE11BIfMGHGN9lnuqgR4AzXw/values/Sheet5!A1%3AD10?alt=json&valueInputOption=USER_ENTERED&access_token=AIzaSyDFZO_3jtWjMiXLtHOqggQt6ZNo9hKTqe0&key=\(tk)"

func writeToGoogleSheets(_ accessToken: String) {
    // Construct your API request to write to Google Sheets
    // Example: Use URLSession to send a POST request to the Sheets API with the appropriate data and access token in the headers
    
    let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/1eeEqF-tYX8hBLfAG9zeoE11BIfMGHGN9lnuqgR4AzXw/values/RANGE:append")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Add the access token to the Authorization header
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    // Add the request body data if necessary
    
    // Send the request and handle the response
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("API request error: \(error.localizedDescription)")
            return
        }
        print("ddd \(String(describing: data))")
        
        // Handle the API response
        // Example: Check the response status code and parse the response data
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Response status code: \(httpResponse.statusCode)")
        }
        
        if let responseData = data {
            let responseString = String(data: responseData, encoding: .utf8)
            print("Response data: \(responseString ?? "")")
        }
    }
    
    task.resume()
}








func getLoggedInUser(user:String) -> String {
    let returned_string = ""
    return String(user.split(separator: " (")[0].split(separator: "\\").last!)
}

func gridColumns(columns:Int) -> [GridItem]{
    var grid_columns: [GridItem] = []
    for i in 0...columns - 1 {
        grid_columns.append(GridItem(.flexible()))
    }
    return grid_columns
}

func getDeviceOrientation() -> String {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
        if verticalSizeClass == .compact {
            return "Landscape"
        } else {
            return "Portrait"
        }
    }
struct ImageGroup: Identifiable{
    let id = UUID().uuidString
    var images: [Image]
}
func getFlames(severity: String) -> [Image] {
    var image_group = ImageGroup(images: [])
    switch severity{
    case "High":
        for _ in 0...3{
            image_group.images.append(Image(systemName: "flame"))
        }
    case "Medium":
        for _ in 0...2{
            image_group.images.append(Image(systemName: "flame"))
        }
    case "Low":
        for _ in 0...1{
            image_group.images.append(Image(systemName: "flame"))
        }
    default:
        image_group.images = [Image(systemName: "flame")]
    }
    return image_group.images
}
