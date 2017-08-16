//
//  Globals.swift
//  Anime Serie
//
//  Created by Gustavo Carreno on 8/14/17.
//  Copyright © 2017 GECV. All rights reserved.
//

import UIKit
import Foundation
import CoreData

struct GlobalsVariables {
    
    static let urlmaster : String = "https://anilist.co/api/"
    static var access_token : String = ""
    
}

func getContext () -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}

func deleteAnimes() {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let context = delegate.persistentContainer.viewContext
    
    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AnimeSerie")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    do {
        try context.execute(deleteRequest)
        try context.save()
    } catch {
        print ("There was an error")
    }
  }

func storeAnime (idSerie: String,title_english:String,title_japanese:String,title_romaji:String,img_banner:String,img_lge:String,img_med:String,img_sml:String,average:String) {
    //title_english,title_japanese,title_romaji,image_url_banner,image_url_lge,image_url_med,image_url_sml,average_score,id
    let context = getContext()
    //retrieve the entity that we just created
    let entity =  NSEntityDescription.entity(forEntityName: "AnimeSerie", in: context)
    let transc = NSManagedObject(entity: entity!, insertInto: context)
    //set the entity values
    transc.setValue(idSerie, forKey: "idserie")
    transc.setValue(title_english, forKey: "title_english")
    transc.setValue(title_japanese, forKey: "title_japanese")
    transc.setValue(title_romaji, forKey: "title_romaji")
    transc.setValue(img_banner, forKey: "image_url_banner")
    transc.setValue(img_lge, forKey: "image_url_lge")
    transc.setValue(img_med, forKey: "image_url_med")
    transc.setValue(img_sml, forKey: "image_url_sml")
    transc.setValue(average, forKey: "average_score")
    //save the object
    do {
        try context.save()
         print("EXITO")
    } catch let error as NSError  {
        print("Couldnot save \(error), \(error.userInfo)")
        //return false
    } catch {
        print("ERROR AL FINAL")
        //return false
    }
}
