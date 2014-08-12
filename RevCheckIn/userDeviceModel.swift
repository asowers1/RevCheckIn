//
//  userDeviceModel.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/11/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import CoreData
class userDeviceModel: NSManagedObject {
    @NSManaged var device: String
    @NSManaged var username: String
}