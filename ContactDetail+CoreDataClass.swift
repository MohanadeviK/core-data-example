//
//  ContactDetail+CoreDataClass.swift
//  Example-CoreData
//
//  Created by Madhubalan on 14/02/17.
//  Copyright © 2017 RealImages. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class ContactDetail: NSManagedObject
{
    
    class func saveDetails(contactName : String, contactNo : Int64, contactPhoto : NSData) -> ContactDetail
    {
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "ContactDetail",
                                                 in:managedContext)
        let contactObj = NSManagedObject(entity: entity!,
                                         insertInto: managedContext) as! ContactDetail
        
        contactObj.name = contactName
        contactObj.phoneNo = contactNo
        contactObj.contactPhoto = contactPhoto
        contactObj.createdAt = NSDate()
        contactObj.updatedAt = NSDate()
        
        do
        {
            try managedContext.save()
            return contactObj
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        return contactObj
    }
    
    
    // Fetch datas from the TitleTable
    
    class func fetchDetails(pheNo : Int64)  -> ContactDetail?
    {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactDetail")
        let predicate = NSPredicate(format: "phoneNo == %llu", pheNo)
        fetchRequest.predicate = predicate
        
        do
        {
            let results =
                try managedContext.fetch(fetchRequest)
            var result : ContactDetail?
            if (results.count > 0)
            {
                result = results.first as? ContactDetail
            }
            return result
            
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    
    
    class func updateContent(name : String, contactObj : NSManagedObjectID) -> Bool
    {
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let contact = managedContext.object(with: contactObj)
        
        let contactObj = contact as! ContactDetail
        contactObj.name = name
        contactObj.updatedAt = NSDate()
        do
        {
            try managedContext.save()
            return true
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        return true
        
    }
}
