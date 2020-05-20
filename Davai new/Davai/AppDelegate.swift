//
//  AppDelegate.swift
//  Davai
//
//  Created by MacBook  on 1/28/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import IQKeyboardManager
import FBSDKCoreKit
import FacebookCore
import GoogleSignIn
import TwitterKit
import Firebase
import UserNotifications
import FirebaseMessaging
let APPLANGUAGE = Bundle.main.preferredLocalizations.first
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
   

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       
        
        //
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userId = UserDefaults.standard.string(forKey: "userId")
        let clientId = UserDefaults.standard.string(forKey: "clientId")
        if Helper.getFromUserDefault(key: "userId") == "" && Helper.getFromUserDefault(key: "clientId") == "" {
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "lang")
            
            self.window?.rootViewController = initialViewController
            
           
        }
        else{
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController")
            
            self.window?.rootViewController = initialViewController      
        }
       
        //
        if #available(iOS 10.0, *) {
            FirebaseApp.configure()
            Messaging.messaging().delegate = self
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) {
                    [weak self] granted, error in
                    print("Permission granted: \(granted)")
                    guard granted else { return }
                    self?.getNotificationSettings()
            }
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
            UIApplication.shared.registerForRemoteNotifications()
        }
        Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().shouldEstablishDirectChannel = true
		// Override point for customization after application launch.
         
        GIDSignIn.sharedInstance().clientID = "469055479249-teml5ok9i5hc12he8ov3amdekta6sgpi.apps.googleusercontent.com"
        TWTRTwitter.sharedInstance().start(withConsumerKey:"tBZezPTeFKd8ty4SJ5GplZyrT", consumerSecret:"mflh8I93oScSFjpAZf1TQdlJYHwEfNTNCRaV2yRk9uHThF40L2")
      
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

       
//         let navigationBar =  UINavigationBar.appearance()
//        let gradient = CAGradientLayer()
//        gradient.frame = navigationBar.bounds
//        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
//        navigationBar.setBackgroundImage(image(from: gradient), for: .default)

        IQKeyboardManager.shared().isEnabled = true
		return true
	}
    //
    func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
    print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
    //
    func image(from layer: CALayer?) -> UIImage? {
        UIGraphicsBeginImageContext((layer?.frame.size)!)
        
        if let context = UIGraphicsGetCurrentContext() {
            layer?.render(in: context)
        }
        let outputImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let fb = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String , annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        let twitt = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        if fb == true{
            return fb
        }
        else if twitt == true{
            return twitt
        }
        else {
            return GIDSignIn.sharedInstance().handle(url as URL?,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }    
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let gmail = GIDSignIn.sharedInstance().handle(url,
                                                      sourceApplication: sourceApplication,
                                                      annotation: annotation)
        let fb = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        let options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject, UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
        let twitt = TWTRTwitter.sharedInstance().application(application, open: url, options: options)
        
        if gmail {
            return gmail
        }
        else if twitt {
            return twitt
        }
        else  if fb {
            return fb
        }
        else{return false }
 
    }

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // MySocket.instance.socket.disconnect()
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.addObserver(self, selector:
            #selector(tokenRefreshNotification), name:
            NSNotification.Name.InstanceIDTokenRefresh, object: nil)
      //   MySocket.instance.socket.connect()
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
    
 
    @objc func tokenRefreshNotification(notification: NSNotification) {
        
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            UserDefaults.standard.set(refreshedToken, forKey: "deviceToken")
            //self.sendFCMTokenToServer(token: refreshedToken)
        }
            /*
             Connect to FCM since connection may
             have failed when attempted before having a token.
             */
        else {
            connectToFcm()
        }
    }
    ///
    func connectToFcm() {
    
        Messaging.messaging().connect { (error) in
    if (error != nil) {
    print("Unable to connect with FCM. \(String(describing: error))")
    }
    else {
    print("Connected to FCM.")
    /*
     **this is the token that you have to use**
     print(FIRInstanceID.instanceID().token()!)
     if there was no connection established earlier,
     you can try sending the token again to server.
     */
    
        let token = InstanceID.instanceID().token()!
    //self.sendFCMTokenToServer(token: token)
    
    }
    }
}
}

extension AppDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                  withError error: Error!) {
            if let error = error {
                print("\(error.localizedDescription)")
                // [START_EXCLUDE silent]
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
                // [END_EXCLUDE]
            } else {
                // Perform any operations on signed in user here.
                let userId = user.userID                  // For client-side use only!
                let idToken = user.authentication.idToken // Safe to send to the server
                let fullName = user.profile.name
                let givenName = user.profile.givenName
                let familyName = user.profile.familyName
                let email = user.profile.email
                print("emaillllll \(email)")
                
                
                // [START_EXCLUDE]
                NotificationCenter.default.post(
                    name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                    object: nil,
                    userInfo: ["statusText": "Signed in user:\n\(fullName)"])
                // [END_EXCLUDE]
            }
        }
        
        
    }
    
}
//MARK:- Extenion for Notification
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        //TODO: Handle foreground notification
        if UIApplication.shared.applicationState == .active || UIApplication.shared.applicationState == .background ||
            UIApplication.shared.applicationState == .inactive
        {
            let aps=userInfo[AnyHashable("aps")] as? NSDictionary
            let alert=userInfo["alert"] as? NSDictionary
            let body=userInfo["body"] as? String
            let title=userInfo["title"] as? String
            let imageurl=userInfo["imageurl"] as? String
//            let userid = userRepo.getUser()?.userId
//            //save in coredata
//            let appDelegate=UIApplication.shared.delegate as! AppDelegate
//            let context=appDelegate.persistentContainer.viewContext
//            let newNotification=NSEntityDescription.insertNewObject(forEntityName: "Notification", into: context)
//            newNotification.setValue(title!, forKey: "title")
//            newNotification.setValue(body!, forKey: "body")
//            newNotification.setValue(imageurl!, forKey: "imageurl")
//            newNotification.setValue(userid, forKey: "userid")
//            do{
//                try context.save()
//            }
//            catch{
//                print("error")
//            }
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        //TODO: Handle background notification
        completionHandler()
    }
    //
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let token = Messaging.messaging().fcmToken
        let macAddress = UIDevice.current.identifierForVendor?.uuidString
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        print("FCM token: \(token ?? "")")
        print("MacAddress: \(macAddress)")
        
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "token") != nil || userDefaults.object(forKey: "macAddress") != nil{
            userDefaults.removeObject(forKey: "token")
            userDefaults.removeObject(forKey: "macAddress")
        }
        
        userDefaults.setValue(token, forKey: "token")
        userDefaults.setValue(macAddress, forKey: "macAddress")
        userDefaults.synchronize()
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)  {
        if UIApplication.shared.applicationState == .active ||
            UIApplication.shared.applicationState == .background ||
            UIApplication.shared.applicationState == .inactive
        {
            // TODO: Handle foreground notification
            let aps=userInfo[AnyHashable("aps")] as? NSDictionary
            let alert=userInfo["alert"] as? NSDictionary
            let body=userInfo["body"] as? String
            let title=userInfo["title"] as? String
            let imageurl=userInfo["imageurl"] as? String
            print("title \(title)")
//            let userid = userRepo.getUser()?.userId
//            let appDelegate=UIApplication.shared.delegate as! AppDelegate
//            let context=appDelegate.persistentContainer.viewContext
//            let newNotification=NSEntityDescription.insertNewObject(forEntityName: "Notification", into: context)
//            newNotification.setValue(title!, forKey: "title")
//            newNotification.setValue(body!, forKey: "body")
//            newNotification.setValue(imageurl!, forKey: "imageurl")
//            newNotification.setValue(userid, forKey: "userid")
//            do{
//                try context.save()
//            }
//            catch{
//                print("error")
//            }
            completionHandler(UIBackgroundFetchResult.newData)
        }
    }
   /////
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        let d : [String : Any] = remoteMessage.appData["notification"] as! [String : Any]
        let body : String = d["body"] as! String
        print("body\(body)")
    }
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    ////
    @objc func refreshToken(notification: NSNotification){
        let refreshToken = InstanceID.instanceID().token()
        UserDefaults.standard.set(refreshToken, forKey: "userkey")
        print("refreshtoken",refreshToken!)
        FBHandler()
    }
    func FBHandler(){
        Messaging.messaging().shouldEstablishDirectChannel = true
    }

}
