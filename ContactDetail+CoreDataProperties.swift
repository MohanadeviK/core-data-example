//
//  ContactDetail+CoreDataProperties.swift
//  Example-CoreData
//
//  Created by Devi on 16/02/17.
//  Copyright © 2017 RealImages. All rights reserved.
//

import Foundation
import CoreData


extension ContactDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactDetail> {
        return NSFetchRequest<ContactDetail>(entityName: "ContactDetail");
    }

    @NSManaged public var contactPhoto: NSData?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var phoneNo: Int64
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var gender: String?

}
