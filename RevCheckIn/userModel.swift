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
    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var name: String
    @NSManaged var business_name: String
}
