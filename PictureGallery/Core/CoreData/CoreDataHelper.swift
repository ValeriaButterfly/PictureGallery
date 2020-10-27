//
//  CoreDataHelper.swift
//  PictureGallery
//
//  Created by Valeria Muldt on 27.10.2020.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    static let sharedInstanse = CoreDataHelper()
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    
    static let picture = NSEntityDescription.insertNewObject(forEntityName: "Picture", into: context) as! Picture
    
    
    static func saveImage(id: Int, image: UIImage) {
        let imageData = image.pngData()
        
        picture.id = Int32(id)
        picture.image = imageData
        
        do {
            try context.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    static func getImage(array: inout [Picture]) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Picture")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request) as! [Picture]
            for data in result {
                print(data.id)
                array.append(data)
            }
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
    }
}
