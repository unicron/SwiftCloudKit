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
    @IBOutlet var textbox: UITextField!
    @IBOutlet var saveButton: UIButton!
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
    
    
    //MARK: save
    @IBAction func saveButtonClicked(sender: AnyObject) -> Void {
        if textbox.text.isEmpty {
            return
        }
        
        let newRecord = CKRecord(recordType: "TestRecordType")
        let newRecordValue = textbox.text
        newRecord.setObject(newRecordValue, forKey: "TestStringAttribute")
        
        doCloudKitSave(newRecord)
        textbox.text = nil
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
        
        var cell = self.items[indexPath.row]
        
        //this will wait until complete
        self.doCloudKitDelete(nil, deleteRecordIds: [cell.recordID])
        
        self.items.removeAtIndex(indexPath.row)
        self.refreshTable()
    }
    
    func refreshTable() -> Void {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func doCloudKitDelete(saveRecords: [CKRecord]!, deleteRecordIds: [CKRecordID]!) -> Void {
        let publicDb = CKContainer.defaultContainer().publicCloudDatabase
    
        var mod = CKModifyRecordsOperation(recordsToSave: saveRecords, recordIDsToDelete: deleteRecordIds)
        
        //execute faster!
        //mod.queuePriority = NSOperationQueuePriority.High
        publicDb.addOperation(mod)

        mod.waitUntilFinished()
    }
    
    func doCloudKitSave(recordToSave: CKRecord) -> Void {
        let publicDb = CKContainer.defaultContainer().publicCloudDatabase
        
        publicDb.saveRecord(recordToSave, completionHandler: {(savedRecord:CKRecord!, saveError:NSError!) -> Void in
            if saveError != nil {
                println("Error during save!")
                
            } else {
                println("Success!")
                self.items.append(savedRecord)
                self.refreshTable()
            }
        });
    }
    
    func doCloudKitFetch() -> Void {
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
        
        let publicDb = CKContainer.defaultContainer().publicCloudDatabase
        
        //var predicate = NSPredicate(format: "TestStringAttribute = %@", "Blah")
        let predicate = NSPredicate(value: true)  //get all records
        let query = CKQuery(recordType: "TestRecordType", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        publicDb.performQuery(query, inZoneWithID: nil, completionHandler: {(records:[AnyObject]!, fetchError:NSError!) -> Void in
            if fetchError != nil {
                println("Error during fetch!")
                
            } else {
                println("Success!")
                for record in records {
                    let r = record as CKRecord
                    println(r.objectForKey("TestStringAttribute"))
                    println(r.objectForKey("creationDate"))
                    self.items.append(r)
                }
                self.refreshTable()
            }
        });
        
    }
    
    
}

