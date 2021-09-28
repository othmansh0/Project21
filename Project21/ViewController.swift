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

//---------------------------------------------------------------------------------------
//We can now use that same (used in categoryIdentifier) text string to create buttons for the user to choose from, and iOS will show them when any notifications of that type are shown
// done using two new classes: UNNotificationAction creates an individual button for the user to tap, and UNNotificationCategory groups multiple buttons together under a single identifier


//Creating a UNNotificationAction requires:
//
//An identifier, which is a unique text string that gets sent to you when the button is tapped.
//A title, which is what user’s see in the interface.
//Options, which describe any special options that relate to the action. You can choose from .authenticationRequired, .destructive, and .foreground


//intentIdentifiers:let us specify things like talking to siri for example
//-------------------------------------------------------------------------------------
//didReceive method for the notification center called when the user launch our app as a result of notification.This is called on our view controller because we’re the center’s delegate, so it’s down to us to decide how to handle the notification

//We attached some customer data to the userInfo property of the notification content, and this is where it gets handed back – it’s your chance to link the notification to whatever app content it relates to
//content.userInfo = ["customData": "fizzbuzz"]

//When the user acts on a notification you can read its actionIdentifier property to see what they did. We have a single button with the “show” identifier

//UNNotificationDefaultActionIdentifier  gets sent when the user swiped on the notification to unlock their device and launch the app

//---------------------------------------------------------------------------------
//review:
// If a function receives a closure parameter and doesn't use it immediately, it must be marked @escaping.
//Think about it like this: the closure escapes the method rather than being used inside there then thrown away.

//Apps can read a shared notification center using UNUserNotificationCenter.current().


//We can attach a custom data dictionary to our notifications.
//This lets us provide context that gets sent back when the notification action is triggered


// 5.everything from { (granted, error) in to the end is a closure: that code won’t get run straight away. Instead, it gets passed as the second parameter to the requestAuthorization() method, which stores the code. This is important – in fact essential – to the working of this code, because iOS needs to ask the user for permission to show notifications


import UserNotifications
import UIKit

class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
            //request an alert+badge+sound
        //5.
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
        registerCategories()
        let ceneter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late Wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        //you can attach custom actions by specifying categoryIdentifier
        content.categoryIdentifier = "alarm"
        
        //optinal
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
    
    
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        // any alert-based messages that get sent will be routed to our view controller to be handled
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        
        let reminder = UNNotificationAction(identifier: "reminder", title: "remind me laterr", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show,reminder], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
     
    }
    //This might be much later on, so it’s marked with the @escaping keyword
    //like networking or asking for feedback in an alert
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //We attached some customer data to the userInfo property of the notification content, and this is where it gets handed back – it’s your chance to link the notification to whatever app content it relates to
        
        
        
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        
        // we can pull out our user info then decide what to do based on what the user chose.
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                let ac = UIAlertController(title: "Swiped to Unlock", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                print("Default identifier")
                
            case "show":
                // the user tapped our "show more info…" button
                let ac = UIAlertController(title: "Tapped show more info", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                print("Show more information…")
                
            case "reminder":
             
                print("fuck1")
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    print("fuck3")
                    self.scheduleLocal()
                }
                
                print("fuck2")
            
            default:
                break
            }
            
        }
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    
 


}

