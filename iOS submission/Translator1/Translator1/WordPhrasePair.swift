//
//  WordPhrasePair.swift
//  Translator1
//
//  Created by alr16 on 08/05/2015.
//  Copyright (c) 2015 Aberystwyth University. All rights reserved.
//

import Foundation
import CoreData

@objc(WordPhrasePair)
class WordPhrasePair: NSManagedObject {

    @NSManaged var english: String
    @NSManaged var note: String
    @NSManaged var type: String
    @NSManaged var welsh: String
    @NSManaged var tags: NSSet

}
