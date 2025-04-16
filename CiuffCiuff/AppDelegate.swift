//
//  AppDelegate.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/12/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if !self.isAppAlreadyLaunchedOnce() {
            // present tutorial VC
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tutorialVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tutorialViewController")
            self.window?.rootViewController = tutorialVC
            self.window?.makeKeyAndVisible()
            
            return true
        }
        
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("CiuffCiuffGameState.json")
            
            let data = try Data(contentsOf: fileURL)
            let prevGameState = try JSONDecoder().decode(GameState.self, from: data)
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let startVC: HomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            startVC.gameState = prevGameState
            Operation.lastUid = prevGameState.lastUid
            Operation.privateCompanyLabels = (0..<prevGameState.privatesLabels.count).map({ prevGameState.privatesLabels[$0] })
            Operation.opEntityLabels = prevGameState.labels
            Operation.opBaseCompanyLabels = (0..<prevGameState.companiesSize).map({ prevGameState.getCompanyLabel(atBaseIndex: $0) })
            
            self.window?.rootViewController = startVC
            self.window?.makeKeyAndVisible()
            
            return true
            
        } catch {
            
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ViewHome: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "setupViewController")
        self.window?.rootViewController = ViewHome
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if let homeVC = self.window?.rootViewController as? HomeViewController {
            homeVC.gameState.saveToDisk()
        }
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

