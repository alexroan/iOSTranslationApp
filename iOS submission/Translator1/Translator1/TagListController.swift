//
//  TagListController.swift
//  Translator1
//
//  Created by alr16 on 12/05/2015.
//  Copyright (c) 2015 Aberystwyth University. All rights reserved.
//

import UIKit
import CoreData

class TagListController: UITableViewController {

    var managedContext: NSManagedObjectContext! = nil
    var tags : Array<Tag> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedContext = appDelegate.managedObjectContext!
    }
    
    override func viewDidAppear(animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        tags = managedContext!.executeFetchRequest(fetchRequest, error: nil)! as [Tag]
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID: NSString = "TagCell"
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell
        var data: NSManagedObject = tags[indexPath.row] as NSManagedObject
        cell.textLabel?.text = data.valueForKey("name") as? String
        
        var associatedPairs : NSSet = data.valueForKey("wordPhrases") as NSSet
        var numberOfPairs = associatedPairs.count
        cell.detailTextLabel?.text = String(numberOfPairs) + " associated pairs"
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier? == "revise" {
            var rowNumber = self.tableView.indexPathForSelectedRow()?.row
            var selectedItem : Tag = tags[rowNumber!] as Tag
            
            let viewController : RevisionListController = segue.destinationViewController as RevisionListController
            var pairSet : NSSet = selectedItem.valueForKey("wordPhrases") as NSSet
            var pairArray : Array<WordPhrasePair> = pairSet.allObjects as Array<WordPhrasePair>
            viewController.pairs = pairArray
        }
    }
}
