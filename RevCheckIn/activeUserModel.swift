//
//  activeUserModel.swift
//  RevCheckIn
//
//  Created by Andrew Sowers on 8/3/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

import UIKit
import CoreData

@objc(activeUserModel)
class activeUserModel: NSManagedObject {
    @NSManaged var username: String
}
