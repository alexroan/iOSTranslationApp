//
//  RevisionController.swift
//  Translator1
//
//  Created by alr16 on 12/05/2015.
//  Copyright (c) 2015 Aberystwyth University. All rights reserved.
//

import UIKit
import CoreData

class RevisionListController: UITableViewController {
    
    var managedContext: NSManagedObjectContext! = nil
    var pairs : Array<WordPhrasePair> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedContext = appDelegate.managedObjectContext!
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID : NSString = "PairCell"
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell
        var data: NSManagedObject = pairs[indexPath.row] as NSManagedObject
        cell.textLabel?.text = data.valueForKey("english") as? String
        return cell

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier? == "checker" {
            var rowNumber = self.tableView.indexPathForSelectedRow()?.row
            var selectedItem : WordPhrasePair = pairs[rowNumber!] as WordPhrasePair
            let viewController : RevisorController = segue.destinationViewController as RevisorController
            
            viewController.englishVersion = selectedItem.valueForKey("english") as String
            viewController.welshVersion = selectedItem.valueForKey("welsh") as String
            
        }
            
    }
    
}
