//
//  AppDelegate.swift
//  MoviePlanet
//
//  Created by eyup cimen on 22.09.2021.
//

import UIKit

var mainDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            window!.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        return true
    }



}

