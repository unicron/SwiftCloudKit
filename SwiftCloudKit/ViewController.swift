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
    
    //MARK: members
    @IBOutlet var tableView: UITableView!
    var items = [CKRecord]()
    
    
    //MARK: view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.doCloudKitFetch()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: tableView stuff
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel.text = self.items[indexPath.row].objectForKey("TestStringAttribute") as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    func doCloudKitSave(recordToSave: CKRecord) {
        let publicDb = CKContainer.defaultContainer().publicCloudDatabase
        
        publicDb.saveRecord(recordToSave, completionHandler: {(savedRecord:CKRecord!, saveError:NSError!) -> Void in
            if saveError != nil {
                println("Error during save!")
                
            } else {
                println("Success!")
            }
        });
    }
    
    func doCloudKitFetch() {
        let publicDb = CKContainer.defaultContainer().publicCloudDatabase
        
//        let ckRecordId = CKRecordID(recordName: "9f9f6add-e742-4f49-84bc-6476061784f5")
//        publicDb.fetchRecordWithID(ckRecordId, completionHandler: {(fetchedRecord:CKRecord!, saveError:NSError!) -> Void in
//            if saveError != nil {
//                println("Error during fetch!")
//            
//            } else {
//                println("Success!")
//                //fetchedRecord.setObject(2, forKey:"TestIntAttribute")
//                var strAttr = fetchedRecord.objectForKey("TestStringAttribute") as? String
//                fetchedRecord.setObject(strAttr! + "Test", forKey:"TestStringAttribute")
//               
//                self.doCloudKitSave(fetchedRecord);
//            }
//        });
        
        //var predicate = NSPredicate(format: "TestStringAttribute = %@", "Blah")
        let predicate = NSPredicate(value: true)  //get all records
        var query = CKQuery(recordType: "TestRecordType", predicate: predicate)
        publicDb.performQuery(query, inZoneWithID: nil, completionHandler: {(records:[AnyObject]!, fetchError:NSError!) -> Void in
            if fetchError != nil {
                println("Error during fetch!")
                
            } else {
                println("Success!")
                for record in records {
                    let r = record as CKRecord
                    println(r.objectForKey("TestStringAttribute"))
                    self.items.append(r)
                }
                self.tableView.reloadData()
            }
        });
        
    }
    
    
}

