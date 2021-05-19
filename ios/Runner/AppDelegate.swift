import UIKit
import Flutter
import GoogleMaps
//import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCu0yg8GRNWGsBRuB2fstkGaE-niju2UKo")
    GeneratedPluginRegistrant.register(with: self)
    /* FirebaseApp.configure()
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }  */
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

