//
//  AppDelegate.swift
//  HotelLister
//
//  Created by Nicholas Allio on 23/11/2016.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        //UINavigationBar
        UINavigationBar.appearance().barTintColor = UIColor(red: 41/255, green: 135/255, blue: 242/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont.boldSystemFont(ofSize: 24)]
        
        return true
    }

}

