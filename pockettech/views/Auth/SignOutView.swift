//
//  SignOutView.swift
//  pockettech
//
//  Created by Paul Crews on 6/10/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SignOutView: View {
    @State var logged_in = (GIDSignIn.sharedInstance.currentUser?.profile != nil) ? true : false
    var body: some View {
                if !logged_in {
                    ContentView()

            } else {
                VStack{
                    Text("Sorry to see you go")
                        .onAppear {
                            GIDSignIn.sharedInstance.signOut()
                            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                                logged_in = false
                            }
                        }
                }
            }

        }
    }

struct SignOutView_Previews: PreviewProvider {
    static var previews: some View {
        SignOutView()
    }
}
