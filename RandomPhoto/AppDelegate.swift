//
//  AppDelegate.swift
//  RandomPhoto
//
//  Created by Tsuen Hsueh on 2021/9/11.
//

import UIKit
import DatadogCore
import DatadogRUM
import Foundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appID = "8f407934-0887-4eb4-bb46-51020997b31b"
        let clientToken = "pub9e932252b68f07ec5452b962d07a587c"
        let environment = "sankars-xcode"

        Datadog.initialize(
            with: Datadog.Configuration(
                clientToken: clientToken,
                env: environment,
                site: .us1
            ),
            trackingConsent: .granted
        )

        RUM.enable(
            with: RUM.Configuration(
                applicationID: appID,
                uiKitViewsPredicate: DefaultUIKitRUMViewsPredicate(),
                uiKitActionsPredicate: DefaultUIKitRUMActionsPredicate(),
                urlSessionTracking: RUM.Configuration.URLSessionTracking()
            )
        )
        
        URLSessionInstrumentation.enable(
            with: .init(
                delegateClass: DataTaskDelegate.self
            )
        )

        NetworkManager.initialize(session: URLSession(
            configuration: .default,
            delegate: DataTaskDelegate(),
            delegateQueue: nil
        ))
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

class DataTaskDelegate: NSObject, URLSessionDataDelegate {

    // Called when the data task receives data
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("Received data: \(data)")
    }

    // Called when the data task receives a response
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("Received response: \(response)")
        completionHandler(.allow)
    }

    // Called when the task completes
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Task completed with error: \(error)")
        } else {
            print("Task completed successfully")
        }
    }
}

class NetworkManager {
    static var shared: NetworkManager!

    let session: URLSession

    private init(session: URLSession) {
        self.session = session
    }
    
    static func initialize(session: URLSession) {
        shared = NetworkManager(session: session)
    }
    
    func fetchData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = session.dataTask(with: url, completionHandler: completion)
        dataTask.resume()
    }
}
