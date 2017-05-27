//
//  FeedbackDB.swift
//  FoodApp
//
//  Created by VIDYA SAGAR on 04/03/17.
//  Copyright © 2017 VIDYA SAGAR. All rights reserved.
//

import Foundation
import CoreData

class FeedbackDB {

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addFeedback( fb : feedback) -> Bool {
    
        var isSaved = false
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newFB = NSEntityDescription.insertNewObject(forEntityName: "FeedBack", into: context)
        
        newFB.setValue(fb.anonymous, forKey: "anonymous")
        newFB.setValue(fb.created, forKey: "created")
        newFB.setValue(fb.feedbackId, forKey: "feedbackId")
        newFB.setValue(fb.feedbackText, forKey: "feedbackText")
        newFB.setValue(fb.name, forKey: "name")
        newFB.setValue(fb.objectId, forKey: "objectId")
        newFB.setValue(fb.partNumber, forKey: "partNumber")
        newFB.setValue(fb.rating, forKey: "rating")
        newFB.setValue(fb.totalParts, forKey: "totalParts")
        newFB.setValue(fb.updated, forKey: "updated")
        
        do {
           try context.save()
            isSaved = true
        } catch {
            isSaved = false
        }
        
        
        print("new feedback aaded \(isSaved)")
        return isSaved
    }
    
    
    func getFeedback() -> [feedback] {
        var reviews = [feedback]()
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "FeedBack")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    if let fetched = result as? NSManagedObject {
                        let review = feedback()
                        if let anonymous = fetched.value(forKey: "anonymous") as? String? {
                            review.anonymous = anonymous
                        }
                        if let created = fetched.value(forKey: "created") as? NSDate {
                            review.created = created
                        }
                        if let feedbackId = fetched.value(forKey: "feedbackId") as? String? {
                            review.feedbackId = feedbackId
                        }
                        if let feedbackText = fetched.value(forKey: "feedbackText") as? String {
                            review.feedbackText = feedbackText
                        }
                        if let name = fetched.value(forKey: "name") as? String {
                            review.name = name
                        }
                        if let objectId = fetched.value(forKey: "objectId") as? String {
                            review.objectId = objectId
                        }
                        if let partNumber = fetched.value(forKey: "partNumber") as? String? {
                            review.partNumber = partNumber
                        }
                        if let rating = fetched.value(forKey: "rating") as? String? {
                            review.rating = rating
                        }
                        if let totalPart = fetched.value(forKey: "totalParts") as? String? {
                            review.totalParts = totalPart
                        }
                        if let updated = fetched.value(forKey: "updated") as? NSDate {
                            review.updated = updated
                        }
                        reviews.append(review)
                    
                }
            }
            }
        } catch {
        
        }
        
        return reviews
    }
    
    func fbCount() -> Int {
        var count = 0
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "FeedBack")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            count = results.count
        } catch {
        
        }
        return count
    }
    
    func removeFB() -> Bool {
        var isRemoved = false
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "FeedBack")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    context.delete(result as! NSManagedObject)
                    do {
                        try context.save()
                        isRemoved = true
                    } catch {
                        isRemoved = false
                    }
                }
            } else {
                isRemoved = true
            }
        }catch {
            isRemoved = false
        }
        
        print("Feedbacks from db is removed \(isRemoved)")
        return isRemoved
    }

}
