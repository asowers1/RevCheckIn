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
        while myList.isEmpty {myList = context2.executeFetchRequest(freq, error: nil)}
        if let device = myList[0].valueForKeyPath("device") as? String {
            return device
        }
        return "-1"
    }
}
