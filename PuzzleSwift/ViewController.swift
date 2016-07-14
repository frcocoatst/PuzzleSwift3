//
//  ViewController.swift
//  PuzzleSwift
//
//  Created by Friedrich HAEUPL on 10.05.16.
//  Copyright © 2016 Friedrich HAEUPL. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var viewOutlet: MyView!

    @IBAction func doShuffle(sender: AnyObject) {
        NSLog("doShuffle called")
        viewOutlet.shuffle()
        
    }
}

