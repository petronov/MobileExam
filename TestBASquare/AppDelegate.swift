//
//  AppDelegate.swift
//  TestBASquare
//
//  Created by Petro Novosad on 3/2/18.
//  Copyright © 2018 Petro Novosad. All rights reserved.
//
//=============================================================================================

import UIKit

///////////////////////////////////////////////////////////////////////////////////////////////
//    global variable
//      Notification name
//---------------------------------------------------------------------------------------------
public let NoInternetNotification: String = "NoInternetNotification"

///////////////////////////////////////////////////////////////////////////////////////////////
//    global variable
//      Notification name
//---------------------------------------------------------------------------------------------
public let InternetIsAvailableNotification: String = "InternetIsAvailableNotification"


//=============================================================================================
//
//     class AppDelegate
//
//=============================================================================================

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    //---------------------------------------------------------------------------------------------
    
    var window: UIWindow?
    
    //---------------------------------------------------------------------------------------------
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        //------------------------------------------------
        
        if reachability != nil
        {
            reachability!.whenReachable = { _ in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: InternetIsAvailableNotification), object: nil, userInfo: nil)
                }
            }
            
            reachability!.whenUnreachable = { _ in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: NoInternetNotification), object: nil, userInfo: nil)
                }
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(internetChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        
        do {
            try reachability?.startNotifier()
        }
        catch
        {
            print("Could not startnotifier")
        }
        
        //------------------------------------------------
        
        OpenWeatherMapKit.initialize(withAppId: "d2bd923726d8850b7677856f80cb52cd")
        
        //------------------------------------------------
        
        return true
    }
    
    //---------------------------------------------------------------------------------------------
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    //---------------------------------------------------------------------------------------------

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    //---------------------------------------------------------------------------------------------
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    //---------------------------------------------------------------------------------------------
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    //---------------------------------------------------------------------------------------------
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //---------------------------------------------------------------------------------------------
    // MARK: Reachability
    //---------------------------------------------------------------------------------------------
    
    let reachability = Reachability()
    
    //---------------------------------------------------------------------------------------------
    
    @objc func internetChanged(note: Notification)
    {
        if let reachability = note.object as? Reachability
        {
            if reachability.isReachable
            {
                DispatchQueue.main.async {
                    ViewController.internetIsReachableInUI = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: InternetIsAvailableNotification), object: nil, userInfo: nil)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    ViewController.internetIsReachableInUI = false
                    NotificationCenter.default.post(name: Notification.Name(rawValue: NoInternetNotification), object: nil, userInfo: nil)
                }
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------
}

//==== class AppDelegate ======================================================================

