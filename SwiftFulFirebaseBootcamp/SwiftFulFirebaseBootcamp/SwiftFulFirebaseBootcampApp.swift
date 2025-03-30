//
//  SwiftfulFirebaseBootcampApp.swift
//  SwiftfulFirebaseBootcamp
//


import SwiftUI
import Firebase

@main
struct SwiftfulFirebaseBootcampApp: App {
    
    // Link to AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // Replace with your initial view
            RootView()
//            CrashView()
//            PerformanceView()
        }
    }
}

// AppDelegate handles Firebase configuration
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Optional: Enable Crashlytics debug mode
        // Uncomment during development if needed
        // let settings = Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // App became active
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // App will resign active
    }
}
