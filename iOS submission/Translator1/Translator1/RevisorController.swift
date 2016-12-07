//
//  RevisorController.swift
//  Translator1
//
//  Created by alr16 on 12/05/2015.
//  Copyright (c) 2015 Aberystwyth University. All rights reserved.
//

import UIKit
import CoreData

class RevisorController: UIViewController {

    var welshVersion: String = ""
    var englishVersion: String = ""
    
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var welshInput: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
        englishLabel.text = englishVersion
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkPressed(sender: AnyObject) {
        var welshInputText = welshInput.text
        if welshVersion.uppercaseString == welshInputText.uppercaseString{
            resultLabel.text = "CORRECT!"
        }
        else{
            resultLabel.text = "Incorrect"
        }
    }

}
