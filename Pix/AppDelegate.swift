//
//  AppDelegate.swift
//  Pix
//
//  Created by Adeola Uthman on 11/15/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit
import Firebase
import AUNavigationMenuController


/* The different pages are global for easy access. */
var landingPage: LandingPage!;
var feedPage: FeedPage!;
var explorePage: ExplorePage!;
var profilePage: ProfilePage!;




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure();
        
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
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

