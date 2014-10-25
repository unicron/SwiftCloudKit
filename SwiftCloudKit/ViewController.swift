//
//  ViewController.swift
//  SwiftCloudKit
//
//  Created by Hannemann on 10/5/14.
//  Copyright (c) 2014 Brendan Hannemann. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.doCloudKitFetch()
        
    }
    
    //MARK: tableView stuff
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    func doCloudKitSave(recordToSave: CKRecord) {
        let publicDb = CKContainer.defaultContainer().publicCloudDatabase
        
        publicDb.saveRecord(recordToSave, completionHandler: { savedRecord, saveError -> Void in
            if (saveError != nil) {
                println("Error")
                
            } else {
                println("Success!")
            }
        });
    }
    
    func doCloudKitFetch() {
        let ckRecordId = CKRecordID(recordName: "TestRecord")
        let publicDb = CKContainer.defaultContainer().publicCloudDatabase
        
        publicDb.fetchRecordWithID(ckRecordId, completionHandler: { fetchedRecord, saveError -> Void in
            if (saveError != nil) {
                println("Error")
                
            } else {
                println("Success!")
                fetchedRecord.setObject(2, forKey:"TestIntAttribute")
                fetchedRecord.setObject("Test", forKey:"TestStringAttribute")
                self.doCloudKitSave(fetchedRecord);
            }
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

