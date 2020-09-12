//
//  AppDelegate.swift
//  DevyTalk
//
//  Created by VIVA_DEV_IOS on 2020/08/25.
//  Copyright © 2020 HeaJiJeon. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseInstallations
import FirebaseCoreDiagnostics
import FBSDKCoreKit
import GoogleSignIn

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
  
  var window: UIWindow?
  
  let tabBar: TabBarViewController = {
    let vc = TabBarViewController()
    vc.modalPresentationStyle = .fullScreen
    vc.modalTransitionStyle = .crossDissolve
    return vc
  }()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure()
    
//    ["20200906".toDate(), "20200907".toDate(), "20200908".toDate(), "20200909".toDate(), "20200910".toDate(), "20200911".toDate(), "20200912".toDate(), "20200913".toDate()].forEach {
//      print($0)
//    }
    
    // fb
    ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
    
    //gid
    GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance()?.delegate = self
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .white
    
    window?.rootViewController = tabBar
    window?.makeKeyAndVisible()
    return true
  }
  
  // MARK: URL
  func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
    
    ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
    
    return GIDSignIn.sharedInstance().handle(url)
  }
  
  // MARK: Gid
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    guard error == nil else {
      if let error = error {
        
      }
      return
    }
    
    guard let user = user else {
      return
    }
    
    
    
    guard let email = user.profile.email,
      let firstName = user.profile.givenName,
      let lastName = user.profile.familyName,
      let id = user.userID else {
        return
    }

    UserDefaults.standard.set(email, forKey: "email")
    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
    
    DatabaseManager.shared.userExists(with: email) { exists in
      if !exists {
        // insert to database
        let chatUser = UserData()
        
//        DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
//          if success {
//            // upload image
//            // google profile
//            if user.profile.hasImage {
//              guard let url = user.profile.imageURL(withDimension: 200) else {
//                return
//              }
//
//              URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
//                guard let data = data else {
//                  return
//                }
//
//                let filename = chatUser.docPic
//                StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
//                  switch result {
//                  case .success(let downloadUrl):
//                    UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")

//                  case .failure(let error):

//                  }
//                })
//              }).resume()
//
//            }
//
//
//          }
//        })
        
        
      }
      
      
    }
    
    guard let authentication = user.authentication else {
    
      return
    }
    
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                   accessToken: authentication.accessToken)
    
    FirebaseAuth.Auth.auth().signIn(with: credential) { (authResult, error) in
      guard authResult != nil, error == nil else {
        
        return
      }
      
      
      NotificationCenter.default.post(name: .didLogInNotification, object: nil)
      
    }
    
  }
  
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    
    
  }
  
  
  // MARK: UISceneSession Lifecycle
  
  @available(iOS 13.0, *)
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
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "DevyTalk")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
}



