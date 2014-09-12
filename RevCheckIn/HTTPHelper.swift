//
//  HTTPHelper.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 7/29/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class HTTPHelper: NSObject {

    func deleteActiveUser(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "Active_user")
        
        var myList: Array<AnyObject> = []
        myList = context.executeFetchRequest(freq, error: nil)!
        if !myList.isEmpty{
            println("deleting context")
            for item in myList {
                context.deleteObject(item as NSManagedObject)
            }
            context.save(nil)
        }
    }
    
    func deleteActiveDevice(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "User_device")
        
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
    
    func setUserContext(username:String) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("Active_user", inManagedObjectContext: context)
        
        var newItem = activeUserModel(entity: en!, insertIntoManagedObjectContext: context)
        newItem.username = (username as NSString).lowercaseString
        context.save(nil)
    }
    
    func setDeviceContext(device:String) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("User_device", inManagedObjectContext: context)
        
        var newItem = userDeviceModel(entity: en!, insertIntoManagedObjectContext: context)
        newItem.device = device
        context.save(nil)
    }
    
    func getDeviceContext()->String{
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        var freq = NSFetchRequest(entityName: "User_device")
        while myList.isEmpty{myList = context2.executeFetchRequest(freq, error: nil)!}
        var selectedItem: NSManagedObject = myList[0] as NSManagedObject
        return selectedItem.valueForKeyPath("device") as String
    }
    
    func login(username:String, password:String){
        var params = ["PUSH_ID":"123", "username":username, "password":password, "call":"login"] as Dictionary
        var request = HTTPTask()
        self.deleteActiveUser()
        request.GET("http://experiencepush.com/rev/rest/", parameters: params, success: {(response: HTTPResponse) -> Void in
            if response.responseObject != nil {
                let data = response.responseObject as NSData
                let datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
                if datastring == "1" {
                    println("success")
                    self.setUserContext(username);
                }else {	
                    println("failure")
                    self.setUserContext("-1")
                }
            }
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
                self.setUserContext("-1")
        })
        println("done")
    }
    
    func register(username:String, password:String, name:String, email:String, registrationCode:String, role:String, phone:String) {
        
        // get user device id token and check for a nil case. If nill, set device to -1(error) state.
        var device_id_data: String? = CoreDataHelper().getUserId()
        var device_id:String = ""
        if let data = device_id_data {
            device_id = data
        }else{
            device_id = "-1"
        }
        
        Crashlytics.setObjectValue("register", forKey: "HTTPHelperAction")
        
        // HTTP POST parameters
        let params = ["PUSH_ID":"123", "username":username, "password":password, "name":name, "email":email, "code":registrationCode,"role":role,"phone":phone, "call":"addNewUser", "device_id": device_id] as Dictionary
        var request = HTTPTask()
        self.deleteActiveUser()
        request.POST("http://experiencepush.com/rev/rest/index.php", parameters: params, success: {(response: HTTPResponse) -> Void in
                let datastring:String = NSString(data:response.responseObject! as NSData, encoding:NSUTF8StringEncoding)
                println("data string: \(datastring)")
                if datastring == "1" {
                    self.setUserContext(username)
                    var backgrounder:HTTPBackground = HTTPBackground()
                    backgrounder.updateUserState(username, self.getState())
                }else {
                    self.setUserContext("-1")
                }
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
                self.setUserContext("-1")
            })

    }
    /*
//    func pushStateChange(username: String, state: String, time:String){
//        let params = ["PUSH_ID":"123","username":username,"state":state, "call":"updateUserState", "appTimestamp": time] as Dictionary
//        var request = HTTPTask()
//        request.POST("http://experiencepush.com/rev/rest/index.php", parameters: params, success: {(response: HTTPResponse) -> Void in
//            let datastring:String = NSString(data:response.responseObject! as NSData, encoding:NSUTF8StringEncoding)
//            if datastring == "1" {
//                println("state sent: \(state)")
//            }else {
//                println("state send failed: \(state)")
//            }
//            },failure: {(error: NSError) -> Void in
//                println("error: \(error)")
//        })
//        
//    }
    */
    func setUserDevice(username: String, device: String){
        let params = ["PUSH_ID":"123","username":username,"device":device,"call":"linkDeviceToUser"] as Dictionary
        var request = HTTPTask()
        request.POST("http://experiencepush.com/rev/rest/index.php", parameters: params, success: {(response: HTTPResponse) -> Void in
            let datastring:String = NSString(data:response.responseObject! as NSData, encoding:NSUTF8StringEncoding)
            if datastring == "1" {
                println("device sent: \(device)")
            }else {
                println("device set failed: \(device)")
            }
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
        })
    }
    
    func getAllUsers(){
        let params = ["PUSH_ID":"123","call":"getAllUsers"];
        var request = HTTPTask()
        request.GET("http://experiencepush.com/rev/rest/index.php", parameters: params, success: {(response: HTTPResponse) -> Void in
            let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(response.responseObject! as NSData, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            // remove all users here:
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext!
            let en = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
            
            let freq = NSFetchRequest(entityName: "User")
        
            var myList: Array<AnyObject> = []
            myList = context.executeFetchRequest(freq, error: nil)!
            if !myList.isEmpty{
                println("deleting context")
                for item in myList {
                    context.deleteObject(item as NSManagedObject)
                }
            }
            context.save(nil)
            
            
            // iterate through users in JSON
            if let ar: [AnyObject] = jsonObject as? [AnyObject]{
                for user in ar{
                    //get all memembers:
                    let business_name: AnyObject! = user["business_name"]
                    let email: AnyObject!         = user["email"]
                    let name: AnyObject!          = user["name"]
                    let phone: AnyObject!         = user["phone"]
                    var picture: String!          = user["picture"] as String
                    let role: AnyObject!          = user["role"]
                    let state: AnyObject!         = user["state"]
                    let timestamp: AnyObject!     = user["timestamp"]
                    let username: String!         = user["username"] as String
                    // add each user per iteration
                    
                    //fixed this, no loner needed
                    //picture = picture + username
                    
                    var newItem = userModel(entity: en!, insertIntoManagedObjectContext: context)
                    
                    if (username as NSObject == NSNull()){
                        Crashlytics.setObjectValue("bad Username", forKey: "username")
                    } else {
                        newItem.setValue(username, forKey: "username")
                    }
                    
                    if (business_name as NSObject == NSNull()){
                        Crashlytics.setObjectValue("bad business_name", forKey: "business_name")
                    } else {
                        newItem.setValue(business_name, forKey: "business_name")
                    }
                    
                    if (picture as NSObject == NSNull()){
                        Crashlytics.setObjectValue("bad picture", forKey: "timepictureStamp")
                    } else {
                        let imageURL : NSURL = NSURL.URLWithString(picture)
                        var err: NSError?
                        let photoData : NSData = NSData(contentsOfURL: imageURL)
                        newItem.setValue(photoData, forKey:"picture")
                    }
                    
                    if (name as NSObject == NSNull()){
                        Crashlytics.setObjectValue("bad name", forKey: "name")
                    } else {
                        newItem.setValue(name, forKey: "name")
                    }
                    
                    if (phone as NSObject == NSNull()){
                        Crashlytics.setObjectValue("bad phone", forKey: "phone")
                    } else {
                        newItem.setValue(phone, forKey: "phone")
                    }
                    
                    if (role as NSObject == NSNull()){
                        Crashlytics.setObjectValue("bad role", forKey: "role")
                    } else {
                        newItem.setValue(role, forKey: "role")
                    }
                    
                    if (state as NSObject == NSNull()){
                        Crashlytics.setObjectValue("bad state", forKey: "state")
                    } else {
                        newItem.setValue(state.stringValue, forKey: "state")
                    }
                    
                    if (timestamp as NSObject == NSNull()){
                        Crashlytics.setObjectValue("bad badTimeStamp", forKey: "timeStamp")
                    } else {
                        newItem.setValue(timestamp, forKey: "timestamp")
                    }
                    
                    if (email as NSObject == NSNull()){
                        Crashlytics.setObjectValue("bad Email", forKey: "email")
                    } else {
                        newItem.setValue(email, forKey: "email")
                    }
                }
            }
            
            context.save(nil)
            
            // do not call this unless users are present in the userModel - requires error handling.
            //self.checkUserModel()
            
            NSNotificationCenter.defaultCenter().postNotificationName("displayUsers", object: self)
        },failure: {(error: NSError) -> Void in
                println("error: \(error)")
        })
    }
    
    func checkUserModel(){
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        var freq = NSFetchRequest(entityName: "User")
        println("checkUserModel getContext")
        while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)!}
        println("checkUserModel gotContext")
        for item in myList {
            if let selectedItem: NSManagedObject = item as? NSManagedObject{
                println(item.valueForKeyPath("username") as String)
                println(item.valueForKeyPath("phone") as String)
            }else{
                println("users nil");
            }
        }
    }
    
    
    func getState() -> String {
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        var freq = NSFetchRequest(entityName: "User_status")
        while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)!}
        var selectedItem: NSManagedObject = myList[0] as NSManagedObject
        return selectedItem.valueForKeyPath("checked_in") as String
    }
}
