//
//  AppDelegate.swift
//  Pix
//
//  Created by Adeola Uthman on 11/15/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import AUNavigationMenuController
import SwiftMessages
import OneSignal


/* The different pages are global for easy access. */
var landingPage: LandingPage!;
var feedPage: FeedPage!;
var explorePage: ExplorePage!;
var profilePage: ProfilePage!;




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // OneSignal notifications.
        //Add this line. Replace '5eb5a37e-b458-11e3-ac11-000c2940e62c' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions, appId: "fb3565b9-e3a5-4f4a-b372-b8d528072c3c", handleNotificationReceived: { (notification: OSNotification?) in
            
        }, handleNotificationAction: { (result: OSNotificationOpenedResult?) in
            
        }, settings: [kOSSettingsKeyInFocusDisplayOption : OSNotificationDisplayType.none.rawValue]);
        OneSignal.registerForPushNotifications();
        
        
        // Notifications
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications();
        
        
        FIRApp.configure();
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: .firInstanceIDTokenRefresh, object: nil)
        
        
        
        
        // Create the window manually
        window = UIWindow(frame: UIScreen.main.bounds);
        window?.makeKeyAndVisible();
        
        // Appearance
        UINavigationBar.appearance().barTintColor = UIColor(red: 41/255, green: 200/255, blue: 153/255, alpha: 1);
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white];
        application.statusBarStyle = .lightContent;
        
        
        // Create the views
        landingPage = LandingPage();
        feedPage = FeedPage(collectionViewLayout: createCollectionViewLayout());
        explorePage = ExplorePage(style: .plain);
        profilePage = ProfilePage(collectionViewLayout: createCollectionViewLayout());
        
        let navContr = AUNavigationMenuController(rootViewController: landingPage);
        
        /* Add all of the views as menu items. */
        navContr.addMenuItem(name: "Home", image: nil, destination: feedPage, completion: nil);
        navContr.addMenuItem(name: "Explore", image: nil, destination: explorePage, completion: nil);
        navContr.addMenuItem(name: "Profile", image: nil, destination: profilePage, completion: { void in
            profilePage.useUser = currentUser;
            profilePage.navigationItem.title = "Profile";
            profilePage.canChangeProfilePic = true;
            profilePage.followButton.isHidden = true;
            profilePage.viewDidAppear(true);
        });
        
        /* Set the root view controller. */
        window?.rootViewController = navContr;
        
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .vertical;
        return layout;
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect();
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm();
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    /********************************
     *
     *        NOTIFICATIONS
     *
     ********************************/
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        var formattedMessage: String!;
        if let message = userInfo["aps"] {
            formattedMessage = "\(message)";
            formattedMessage = formattedMessage.substring(i: formattedMessage.indexOf(string: "\"") + 1, j: formattedMessage.indexOf(string: ";") - 1);
            displayMessageAlert(messageID: formattedMessage);
        }
        
        // Print full message.
        //print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        var formattedMessage: String!;
        if let message = userInfo["aps"] {
            formattedMessage = "\(message)";
            formattedMessage = formattedMessage.substring(i: formattedMessage.indexOf(string: "\"") + 1, j: formattedMessage.indexOf(string: ";") - 1);
            displayMessageAlert(messageID: formattedMessage);
        }
        
        // Print full message.
        //print(userInfo);
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if FIRInstanceID.instanceID().token() != nil {
            //print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                //print("Unable to connect with FCM. \(error)")
            } else {
                //print("Connected to FCM.")
            }
        }
    }
    
    
    func displayMessageAlert(messageID: Any) {
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .CardView);
        
        // Theme message elements with the warning style.
        view.configureTheme(.warning);
        
        // Add a drop shadow.
        view.configureDropShadow();
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        view.configureContent(title: "Pix", body: "\(messageID)", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil);
        view.configureTheme(backgroundColor: UIColor(red: 41/255, green: 200/255, blue: 173/255, alpha: 1), foregroundColor: .black);
        view.button?.backgroundColor = UIColor(red: 41/255, green: 200/255, blue: 173/255, alpha: 1);

        
        var config = SwiftMessages.Config()
        config.presentationStyle = .top;
        config.duration = .seconds(seconds: 3);
        config.preferredStatusBarStyle = .lightContent
        config.eventListeners.append() { event in
            if case .didHide = event { print("yep") }
        }
        
        // Show the message.
        SwiftMessages.show(view: view)
    }
    
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        //print("----------> APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
        let defaults = UserDefaults.standard;
        defaults.setValue(deviceTokenString, forKey: "deviceToken");
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        //print("----------> APNs registration failed: \(error)")
    }
}

