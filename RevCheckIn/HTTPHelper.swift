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
        myList = context.executeFetchRequest(freq, error: nil)
        if !myList.isEmpty{
            println("deleting context")
            for item in myList {
                context.deleteObject(item as NSManagedObject)
            }
        }
        context.save(nil)
    }
    
    func deleteActiveDevice(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let freq = NSFetchRequest(entityName: "User_device")
        
        var myList: Array<AnyObject> = []
        myList = context.executeFetchRequest(freq, error: nil)
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
        
        var newItem = activeUserModel(entity: en, insertIntoManagedObjectContext: context)
        newItem.username = username
        context.save(nil)
    }
    
    func setDeviceContext(device:String) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("User_device", inManagedObjectContext: context)
        
        var newItem = userDeviceModel(entity: en, insertIntoManagedObjectContext: context)
        newItem.device = device
        context.save(nil)
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
    }
    
    func register(username:String, password:String, name:String, email:String, businessName:String) {
        let params = ["PUSH_ID":"123", "username":username, "password":password, "name":name, "email":email, "business_name":businessName, "call":"addNewUser"] as Dictionary
        var request = HTTPTask()
        self.deleteActiveUser()
        request.POST("http://experiencepush.com/rev/rest/index.php", parameters: params, success: {(response: HTTPResponse) -> Void in
                let datastring:String = NSString(data:response.responseObject! as NSData, encoding:NSUTF8StringEncoding)
                println("data string: \(datastring)")
                if datastring == "1" {
                    self.setUserContext(username)
                    self.pushStateChange(username, state: self.getState())
                }else {
                    self.setUserContext("-1")
                }
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
                self.setUserContext("-1")
            })
    }
    
    func pushStateChange(username: String, state: String){
        let params = ["PUSH_ID":"123","username":username,"state":state, "call":"updateUserState"] as Dictionary
        var request = HTTPTask()
        request.POST("http://experiencepush.com/rev/rest/index.php", parameters: params, success: {(response: HTTPResponse) -> Void in
            let datastring:String = NSString(data:response.responseObject! as NSData, encoding:NSUTF8StringEncoding)
            if datastring == "1" {
                println("state sent: \(state)")
            }else {
                println("state send failed: \(state)")
            }
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
        })
        
    }
    
    func setUserDevice(username: String, device: String){
        let params = ["PUSH_ID":"123","username":username,"device":device] as Dictionary
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
            
            var myList: Array<AnyObject> = NSJSONSerialization.JSONObjectWithData(response.responseObject as NSData, options: NSJSONReadingOptions.MutableContainers, error: nil) as Array
            
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
                self.setUserContext("-1")
        })
    }
    
    func getState() -> String {
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        var freq = NSFetchRequest(entityName: "User_status")
        while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)}
        var selectedItem: NSManagedObject = myList[0] as NSManagedObject
        return selectedItem.valueForKeyPath("checked_in") as String
    }
}
