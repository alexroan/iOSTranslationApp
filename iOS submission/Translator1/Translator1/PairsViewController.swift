//
//  PairsViewController.swift
//  Translator1
//
//  Created by alr16 on 08/05/2015.
//  Copyright (c) 2015 Aberystwyth University. All rights reserved.
//

import UIKit
import CoreData

class PairsViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var managedContext: NSManagedObjectContext! = nil
    var pairs : Array<WordPhrasePair> = []
    var filteredPairs : Array<WordPhrasePair> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedContext = appDelegate.managedObjectContext!
    }
    
    func filterContentForSearch(searchText: String){
        self.filteredPairs = self.pairs.filter({(wordPhrase: WordPhrasePair) -> Bool in
            let englishText = wordPhrase.english.uppercaseString
            let searchTextUpper = searchText.uppercaseString
            let stringMatch1 = englishText.rangeOfString(searchTextUpper)
            
            let welshText = wordPhrase.welsh.uppercaseString
            let stringMatch2 = welshText.rangeOfString(searchTextUpper)
            return (stringMatch1 != nil) || (stringMatch2 != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearch(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearch(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    //when create comes back
    override func viewDidAppear(animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "WordPhrasePair")
        pairs = managedContext!.executeFetchRequest(fetchRequest, error: nil)! as [WordPhrasePair]
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier? == "show" {
            
            var rowNumber = self.tableView.indexPathForSelectedRow()?.row
            var selectedItem: NSManagedObject
            if (self.searchDisplayController?.active != false){
                rowNumber = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()?.row
                selectedItem = filteredPairs[rowNumber!] as NSManagedObject
            }
            else{
                selectedItem = pairs[rowNumber!] as NSManagedObject
            }
            
            let viewController: NewPairViewController = segue.destinationViewController as NewPairViewController
            viewController.englishText = selectedItem.valueForKey("english") as String
            viewController.welshText = selectedItem.valueForKey("welsh") as String
            viewController.noteText = selectedItem.valueForKey("note") as String
            viewController.typeText = selectedItem.valueForKey("type") as String
            
            var tags: NSSet = selectedItem.valueForKey("tags") as NSSet
            var tagString : String = ""
            var count = 0
            for thisTag in tags{
                var name = thisTag.valueForKey("name") as String
                if count == tags.count-1{
                    tagString = tagString + name
                }
                else{
                    tagString = tagString + name + ","
                }
                count++
            }
            viewController.tagsText = tagString
            viewController.existingPair = selectedItem
        }            
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID: NSString = "Cell"
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell
        
        var data: NSManagedObject
        if tableView == searchDisplayController!.searchResultsTableView{
            data = filteredPairs[indexPath.row] as NSManagedObject
        }
        else{
            data = pairs[indexPath.row] as NSManagedObject
        }
        
        cell.textLabel?.text = data.valueForKey("english") as? String
        cell.detailTextLabel?.text = data.valueForKey("welsh") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            managedContext.deleteObject(pairs[indexPath.row] as NSManagedObject)
            pairs.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            
            var error: NSError? = nil
            if !managedContext.save(&error){
                NSLog("Could not delete")
                abort()
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView{
            return filteredPairs.count
        }
        else{
            return pairs.count
        }
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
