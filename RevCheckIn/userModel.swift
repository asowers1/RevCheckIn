//
//  userModel.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/1/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import CoreData
class userModel: NSManagedObject {
    @NSManaged var picture: NSData
    @NSManaged var role: String
    @NSManaged var state: String
    @NSManaged var time_stamp: String
    @NSManaged var phone: String
    @NSManaged var id: String
    @NSManaged var username: String
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var business_name: String
}
