//
//  NewPairViewController.swift
//  Translator1
//
//  Created by alr16 on 08/05/2015.
//  Copyright (c) 2015 Aberystwyth University. All rights reserved.
//

import UIKit
import CoreData

class NewPairViewController: UIViewController{
    
    @IBOutlet weak var english: UITextField!
    @IBOutlet weak var welsh: UITextField!
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var tags: UITextField!
    
    var englishText: String = ""
    var welshText: String = ""
    var noteText: String = ""
    var typeText: String = ""
    var tagsText: String = ""
    
    var existingPair: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if((existingPair) != nil){
            english.text = englishText
            welsh.text = welshText
            note.text = noteText
            type.text = typeText
            tags.text = tagsText
        }
    }
    
    func addRelations(newTag : Tag, newPair : WordPhrasePair){
        var relatedPairs = newTag.mutableSetValueForKey("wordPhrases")
        relatedPairs.addObject(newPair)
        
        var relatedTags = newPair.mutableSetValueForKey("tags")
        relatedTags.addObject(newTag)
    }
    
    @IBAction func createButtonPressed(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let pairEntityDescription = NSEntityDescription.entityForName("WordPhrasePair", inManagedObjectContext: managedContext)
        let tagEntityDescription = NSEntityDescription.entityForName("Tag", inManagedObjectContext: managedContext)
        
        let tagFetch = NSFetchRequest(entityName: "Tag")
        var error: NSError?
        
        if (existingPair != nil){
            existingPair.setValue(english.text as String, forKey: "english")
            existingPair.setValue(welsh.text as String, forKey: "welsh")
            existingPair.setValue(note.text as String, forKey: "note")
            existingPair.setValue(type.text as String, forKey: "type")
            //Save new tags, check if already there? --later
            
        }
        else{
            var newPair = WordPhrasePair(entity: pairEntityDescription!, insertIntoManagedObjectContext: managedContext)
            newPair.english = english.text
            newPair.welsh = welsh.text
            newPair.note = note.text
            newPair.type = type.text
            
            var fullTags = tags.text.uppercaseString
            let tagsArray = fullTags.stringByReplacingOccurrencesOfString(" ", withString: "").componentsSeparatedByString(",")
            for thisTagText in tagsArray{
                
                var newTag : Tag
                let predicate = NSPredicate(format: "name == %@",thisTagText)
                tagFetch.predicate = predicate
                
                if let results = managedContext.executeFetchRequest(tagFetch, error: &error) as? [Tag]{
                    if(results.count == 0){
                        newTag = Tag(entity: tagEntityDescription!, insertIntoManagedObjectContext: managedContext)
                        newTag.name = thisTagText
                        
                        addRelations(newTag, newPair: newPair)
                    }
                    else{
                        var existingTag : Tag = results[0] as Tag
                        addRelations(existingTag, newPair: newPair)
                    }
                }
            }
        }
        
        managedContext.save(&error)
        if let err = error{
            NSLog("Error saving: \(err)")
        }
        else{
            NSLog("Saved \(english)")
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
