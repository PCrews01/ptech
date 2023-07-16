//
//  LoginView.swift
//  pockettech
//
//  Created by Paul Crews on 6/10/23.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

class GoogleUser:ObservableObject {
    let id = UUID().uuidString
    var name: String = ""
    var email: String = ""
    var first: String = ""
    var last: String = ""
    var image: URL = URL(string: "") ?? URL(string: "https://fonts.gstatic.com/s/i/productlogos/googleg/v6/16px.svg")!
}
struct GoogleProfile{
    let familyName: String
    let givenName:String
    let image: URL
    let email: String
    let name: String
}
struct LoginView: View {
    
    @AppStorage("mex") var un = ""
    @State var nn: GIDProfileData = GIDProfileData()
    @State private var current_user = GIDSignIn.sharedInstance.currentUser?.profile ?? GIDProfileData()
    
    var body: some View {
        VStack{
            if current_sign_in != GIDProfileData() || GIDSignIn.sharedInstance.currentUser != nil {
                AsyncImage(url: current_sign_in != GIDProfileData() ? current_user.imageURL(withDimension: 500) : GIDSignIn.sharedInstance.currentUser?.profile?.imageURL(withDimension: 500))
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
                Text("Hello, \(current_sign_in != GIDProfileData() ? current_user.name : GIDSignIn.sharedInstance.currentUser!.profile!.name)")
                Spacer()
                NavigationLink {
                    SignOutView()
                } label: {
                        Text("Sign Out")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding()
                        .background(.red)
                        .cornerRadius(12)
                        .frame(width: 200, height: 30)
                }
            } else{
                Text("Sign In")
                GoogleSignInButton {
                    handleSignInButtons()
                }.frame(width: 200)
            }
        }.onAppear {
            if((GIDSignIn.sharedInstance.currentUser?.profile?.email) != nil) {
                current_sign_in = GIDSignIn.sharedInstance.currentUser?.profile
            }
        }
    }
    func handleSignInButtons() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController){
            signin, err in
            if let error = err{
                print("Error signing in: \(error)")
            }else{
                let user = signin!.user
                let user_profile = signin!.user.profile
                current_sign_in = signin!.user.profile
                let g_user = GoogleUser()
                g_user.email = user_profile!.email
                g_user.first = user_profile!.givenName!
                g_user.last = user_profile!.familyName!
                g_user.image = user.profile!.imageURL(withDimension: 1920) ?? URL(string: "https://fonts.gstatic.com/s/i/productlogos/googleg/v6/16px.svg")!
                UserDefaults.standard.set(user_profile?.name, forKey: "mex")
                
                let additional_scopes = [
                    "https://www.googleapis.com/auth/spreadsheets",
                    "https://www.googleapis.com/auth/spreadsheets.readonly",
                    "https://www.googleapis.com/auth/documents",
                    "https://www.googleapis.com/auth/documents.readonly",
                    "https://www.googleapis.com/auth/drive",
                    "https://www.googleapis.com/auth/drive.readonly",
                    "https://www.googleapis.com/auth/drive.file"]
                let granted_scopes = user.grantedScopes
                print("Granted \(String(describing: granted_scopes))")
                    user.addScopes(additional_scopes, presenting: presentingViewController){
                        signInResult, error in
                        
                        guard error == nil else { return }
                        guard let signInResult = signInResult else {
                            return
                            
                        }
                    }
                
            }
        }
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
