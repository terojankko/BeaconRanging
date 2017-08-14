//
//  AppDelegate.swift
//  BeaconRanging
//
//  Created by Tero on 8/3/17.
//  Copyright © 2017 Tero. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        locationManager.delegate = self
        return true
    }
    
    
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        print("Exit")
        let content = UNMutableNotificationContent()
        content.title = "Beacon Ranging"
        content.body = "Exit"
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "BeaconRanging", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        print("Enter")
        let content = UNMutableNotificationContent()
        content.title = "Beacon Ranging"
        content.body = "Enter"
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "BeaconRanging", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
