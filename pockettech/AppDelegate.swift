import GoogleSignIn

// Inside your AppDelegate class
public var current_sign_in = GIDSignIn.sharedInstance.currentUser?.profile ?? nil


func application(_ application: UIApplication , didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    print("Application")
    // Add your other setup code here

    // Initialize the GoogleSignIn SDK
//    GIDSignIn.sharedInstance.configuration?.
    GIDSignIn.sharedInstance.restorePreviousSignIn(){ user, err in
        print("Ret")
    }

    return true
}

// Add the following method to handle the callback URL when the user signs in with Google
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
}
