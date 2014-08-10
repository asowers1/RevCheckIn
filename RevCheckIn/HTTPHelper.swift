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
    
    func setUserContext(username:String) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("Active_user", inManagedObjectContext: context)
        
        var newItem = activeUserModel(entity: en, insertIntoManagedObjectContext: context)
        newItem.username = username
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
        var params = ["PUSH_ID":"123", "username":username, "password":password, "name":name, "email":email, "business_name":businessName, "call":"addNewUser"] as Dictionary
        var request = HTTPTask()
        self.deleteActiveUser();
        request.POST("http://experiencepush.com/rev/rest/", parameters: params, success: {(response: HTTPResponse) -> Void in
            let datastring:String = NSString(data:response.responseObject! as NSData, encoding:NSUTF8StringEncoding)
                if datastring == "1" {
                    self.setUserContext(username)
                }else {
                    self.setUserContext("-1")
                }
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
                self.setUserContext("-1")
            })
    }
}
