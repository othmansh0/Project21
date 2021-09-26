//
//  ViewController.swift
//  Project21
//
//  Created by othman shahrouri on 9/26/21.
//


// to request a permission a method called requestAuthorization() on UNUserNotificationCenter

//notification request is split into two components. For example, the trigger – when to show the notification – can be a calendar trigger that shows the notification at an exact time, it can be an interval trigger that shows the notification after a certain time interval has lapsed, or it can be a geofence that shows the notification based on the user’s location

//calendar triggers requires learning another new data type called DateComponents

//If you want to specify a sound you can create a custom UNNotificationSound object and attach it to the sound property, or just use UNNotificationSound.default

import UserNotifications
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
            //request an alert+badge+sound
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("yay")
            } else {
                print("shit")
            }
            
        }
        
    }
    
//  configure all the data needed to schedule a notification
//  1.content (what to show)
//  2.a trigger (when to show it)
//  3.a request (the combination of content and trigger.)
    @objc func scheduleLocal() {
        let ceneter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late Wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        //you can attach custom actions by specifying categoryIdentifier
        content.categoryIdentifier = "alarm"
        
        //To attach custom data to the notification,
        //e.g. an internal ID, use the userInfo dictionary property
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        
        
    }

}

