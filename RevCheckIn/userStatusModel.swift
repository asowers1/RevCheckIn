//
//  userStatusModel.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/1/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import CoreData
class userStatusModel: NSManagedObject {
    @NSManaged var checked_in: String
}