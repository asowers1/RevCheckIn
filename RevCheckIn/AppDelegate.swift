//
//  AppDelegate.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 7/27/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, NSURLSessionDelegate  {
                            
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    var myList: Array<AnyObject> = []
    
    var isIn : Bool = false

    var completionHandler:()->Void={}
    

    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        self.completionHandler = completionHandler
    }

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.

//        if(application.respondsToSelector("registerUserNotificationSettings:")) {
//            application.registerUserNotificationSettings(
//                UIUserNotificationSettings(
//                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
//                    categories: nil
//                )
//            )
//        }
/*
Problems with iOS 7
        var types: UIUserNotificationType = UIUserNotificationType.Badge |
            UIUserNotificationType.Alert |
            UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
*/
        var uuidString:String = "AAAAAAAA-BBBB-BBBB-CCCC-CCCCDDDDDDDD" as String
        let beaconIdentifier = "Push"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        locationManager = CLLocationManager()
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()
    
        UINavigationBar.appearance().barTintColor = UIColor(red: (246/255.0), green: (86/255.0), blue: (12/255.0), alpha: 1)

        Crashlytics.startWithAPIKey("6e63974ab6878886d46e46575c43005ded0cfa08")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        

    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the `inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application( application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData! ) {
        
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
                                            .stringByTrimmingCharactersInSet( characterSet )
                                            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        


        //record user device
        var helper: HTTPHelper = HTTPHelper()
        
        helper.deleteActiveDevice()
        helper.setDeviceContext(deviceTokenString)

        var coreDataHelper: CoreDataHelper = CoreDataHelper()
        println(coreDataHelper.getUserId())
    
        
    }

    func application( application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError! ) {
        
        println("Error: \(error.localizedDescription )")
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "-.RevCheckIn" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: modelURL!)
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the applicati   on. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("RevCheckIn.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}
extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            //NSLog("didRangeBeacons");
            var message:String = ""
            var user:String = ""
            var myList: Array<AnyObject> = []
            var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            var context2: NSManagedObjectContext = appDel2.managedObjectContext!
            let freq = NSFetchRequest(entityName: "Active_user")
            
            myList = context2.executeFetchRequest(freq, error: nil)!
            if !myList.isEmpty {
                var selectedItem: NSManagedObject = myList[0] as
                NSManagedObject
                user = selectedItem.valueForKeyPath("username") as String
            }
            if(beacons.count > 0) {
                
                let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }

                if myList.isEmpty || user != "-1" {
                    if !isIn{
                        isIn = true
                        self.setUserState("1")
                    }
                }
                
                lastProximity = nearestBeacon.proximity;
                switch nearestBeacon.proximity {
                case CLProximity.Far:
                    message = "You are far away from the beacon"
                case CLProximity.Near:
                    message = "You are near the beacon"
                case CLProximity.Immediate:
                    message = "You are in the immediate proximity of the beacon"
                case CLProximity.Unknown:
                    return
                }
            } else {
                if myList.isEmpty || user != "-1" {
                }
                if isIn{
                    isIn = false
                    self.setUserState("0")
                }
                message = "No beacons are nearby"
            }
            
            NSLog("%@", message)
            //sendLocalNotificationWithMessage(message)
    }
    func locationManager(manager: CLLocationManager!,
        didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.startUpdatingLocation()
            var myList: Array<AnyObject> = []
            var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            var context2: NSManagedObjectContext = appDel2.managedObjectContext!
            var freq = NSFetchRequest(entityName: "Active_user")
            
            while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)!}
            var selectedItem: NSManagedObject = myList[0] as NSManagedObject
            var user: String = selectedItem.valueForKeyPath("username") as String
            
            if user != "-1" {
                NSLog("You've checked in, :\(user):")
                sendLocalNotificationWithMessage("You've checked in")
                //var helper = HTTPHelper()
                //helper.pushStateChange(user, state: "1")
                var httpBackgrounder: HTTPBackground = HTTPBackground()
                httpBackgrounder.updateUserState(user, "1")
            }
            else{
            }


    }
    
    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.stopUpdatingLocation()
            var myList: Array<AnyObject> = []
            var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            var context2: NSManagedObjectContext = appDel2.managedObjectContext!
            let freq = NSFetchRequest(entityName: "Active_user")
            
            while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)!}
            var selectedItem: NSManagedObject = myList[0] as
            NSManagedObject
            var user: String = selectedItem.valueForKeyPath("username") as String
            
            if user != "-1" {
                NSLog("You've checked out, :\(user):")

                sendLocalNotificationWithMessage("You've checked out")
                //var helper = HTTPHelper()
                //helper.pushStateChange(user, state: "0")
                var httpBackgrounder: HTTPBackground = HTTPBackground()
                httpBackgrounder.updateUserState(user, "0")
            }
            else{
            }

    }
    
    func setUserState(state:String){
        self.deleteUserStatus()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("User_status", inManagedObjectContext: context)
        var newItem = userStatusModel(entity: en!, insertIntoManagedObjectContext: context)
        newItem.checked_in = state
        context.save(nil)
        println("set state: \(state)")
        
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        let freq = NSFetchRequest(entityName: "Active_user")
        
        while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)!}
        var selectedItem: NSManagedObject = myList[0] as
        NSManagedObject
        var user: String = selectedItem.valueForKeyPath("username") as String
        
        if user != "-1" {
            NSLog("You've checked out, :\(user):")
            
            if (state == "0"){
                sendLocalNotificationWithMessage("You've checked out")
                //var helper = HTTPHelper()
                //helper.pushStateChange(user, state: "0")
                var httpBackgrounder: HTTPBackground = HTTPBackground()
                httpBackgrounder.updateUserState(user, "0")
            } else if (state == "1"){
                NSLog("You've checked in, :\(user):")
                sendLocalNotificationWithMessage("You've checked in")
                //var helper = HTTPHelper()
                //helper.pushStateChange(user, state: "1")
                var httpBackgrounder: HTTPBackground = HTTPBackground()
                httpBackgrounder.updateUserState(user, "1")
            }
        }
    }
    
    func deleteUserStatus(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "User_status")
        
        var myList: Array<AnyObject> = []
        myList = context.executeFetchRequest(freq, error: nil)!
        if !myList.isEmpty{
            println("deleting context")
            for item in myList {
                context.deleteObject(item as NSManagedObject)
            }
        }
        context.save(nil)
    }
}

