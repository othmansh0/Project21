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


//you can cancel pending notifications – i.e., notifications you have scheduled that have yet to be delivered because their trigger hasn’t been met – using the center.removeAllPendingNotificationRequests()


//We can now use that same (used in categoryIdentifier) text string to create buttons for the user to choose from, and iOS will show them when any notifications of that type are shown
// done using two new classes: UNNotificationAction creates an individual button for the user to tap, and UNNotificationCategory groups multiple buttons together under a single identifier


//Creating a UNNotificationAction requires:
//
//An identifier, which is a unique text string that gets sent to you when the button is tapped.
//A title, which is what user’s see in the interface.
//Options, which describe any special options that relate to the action. You can choose from .authenticationRequired, .destructive, and .foreground


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
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 50
       // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //interval trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        
       
        //request ties content and trigger together
        //it has unique identifier a string you create
        //it lets you update or remove notifications programmatically
        // for ex :existing notification to be updated with new information, rather than have multiple notifications from the same app over time
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        ceneter.add(request)
        
    }
    
    
    
    

}

