//
//  CoreDataHelper.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/28/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import Foundation
import CoreData


// eventually, in good practice, perhaps at a later update, we should be doing CoreData functions here.
class CoreDataHelper: NSObject {
    func getUserId()->String{
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        var freq = NSFetchRequest(entityName: "User_device")
        var failSafe: Int = 0
        while myList.isEmpty {
            failSafe++
            if failSafe > 300 {
                return "-1"
            }
            myList = context2.executeFetchRequest(freq, error: nil)!
        }
        if let device = myList[0].valueForKeyPath("device") as? String {
            return device
        }
        return "-1"
    }
    func getUsername()->String{
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        var freq = NSFetchRequest(entityName: "Active_user")
        var writeError: NSError?
        var failSafe: Int = 0
        while myList.isEmpty {
            failSafe++
            if failSafe > 300 {
                self.setUsername("-1")
                return self.getUsername()
            }
            myList = context2.executeFetchRequest(freq, error: &writeError)!
            if let error = writeError {
                println("write failure: \(error.localizedDescription)")
            }
        }
        if let username = myList[0].valueForKeyPath("username") as? String {
            return username
        }
        return "-1"
    }
    func setUsername(username:String){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("Active_user", inManagedObjectContext: context)
        var newItem = activeUserModel(entity: en!, insertIntoManagedObjectContext: context)
        newItem.username = username
        context.save(nil)
        println("set username: \(username)")

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
    func setUserStatus(state:String){
        self.deleteUserStatus()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("User_status", inManagedObjectContext: context)
        var newItem = userStatusModel(entity: en!, insertIntoManagedObjectContext: context)
        newItem.checked_in = state
        context.save(nil)
        println("set state: \(state)")
    }
    func getUserStatus()->String{
        var myList: Array<AnyObject> = []
        var appDel2: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context2: NSManagedObjectContext = appDel2.managedObjectContext!
        var freq = NSFetchRequest(entityName: "User_status")
        while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)!}
        if let status = myList[0].valueForKeyPath("checked_in") as? String {
            return status
        }
        return "-1"
    }
}
