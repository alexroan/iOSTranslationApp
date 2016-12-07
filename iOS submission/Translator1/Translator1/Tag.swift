//
//  Tag.swift
//  Translator1
//
//  Created by alr16 on 08/05/2015.
//  Copyright (c) 2015 Aberystwyth University. All rights reserved.
//

import Foundation
import CoreData

@objc(Tag)
class Tag: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var wordPhrases: NSSet

}
