//
//  StepListViewController.swift
//  Codepath_CBT
//
//  Created by Margaret Bignell on 10/21/15.
//  Copyright © 2015 maggled. All rights reserved.
//

import UIKit
import Parse

class StepListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var stepsTitleLabel: UILabel!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let CellIdentifier = "StepListCell"
    
    var steps: [String]!
    var stepObjects = [PFObject]()
    var stepObject: PFObject!
    var checked = [Bool]()
    var goal: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steps = []

        //setting up cell check mark stuff
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //setting styles
        view.backgroundColor = darkBackgroundColor
        navBarView.backgroundColor = lightBackgroundColor
        navBarView.layer.borderWidth = 1
        navBarView.layer.borderColor = borderColor.CGColor
        
        stepsTitleLabel.textColor = darkTextColor
        
        //setting up table view + styles
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = darkBackgroundColor
        tableView.estimatedRowHeight = 4
        tableView.separatorColor = borderColor
        
        
        let goalQuery = PFQuery(className:"Goal")
        goalQuery.orderByDescending("createdAt")
        
        // get most recent goal
        goalQuery.getFirstObjectInBackgroundWithBlock { (goal: PFObject?, error: NSError?) -> Void in
            if error == nil {
                print("most recent goal retrieved: \(goal!.objectId)")
                
                let stepsQuery = PFQuery(className:"Step")
                stepsQuery.whereKey("goal", equalTo: goal!)
                stepsQuery.orderByAscending("reminder_date")
                
                stepsQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                    var counter = 0
                    for object in objects! {
                        self.stepObjects.insert(object, atIndex: counter)
                        print("stepObjects[\(counter)] = \(self.stepObjects[counter])")
                        
                        let stepsListItem = object["description"] as! String
                        self.steps.append(stepsListItem)
                        print(counter)
                        
                        if (object.objectForKey("completed_at") != nil) {
                            print("completed_at key exists for \(object["objectId"])")
                            self.checked.append(true)
                        } else {
                            print("completed_at key DOES NOT exist for \(object["objectId"])")
                            self.checked.append(false)
                        }
                        
                        counter++
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //back press
    @IBAction func onBackPress(sender: UIButton) {
        navigationController!.popViewControllerAnimated(true)
    }

    //list press action -> navigate to past goals view controller
    @IBAction func onListPress(sender: UIButton) {
        print("list press")

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        //picking up cell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        checked[indexPath.row] = !checked[indexPath.row]
//        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        // set stepObject so we can pass through segue
        stepObject = stepObjects[indexPath.row]
        print("indexPath.row = \(indexPath.row)")
        print("stepObjects[IndexPath.row] = \(stepObjects[indexPath.row])")
        
        //if checked, run segue to complete details view controller
        if checked[indexPath.row] == true {
            performSegueWithIdentifier("stepDetailsCompleteSegue", sender: self)
        }
        //if unchecked, run segue to incomplete view controller
        else {
            performSegueWithIdentifier("stepDetailsIncompleteSegue", sender: self)
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        //addressing cell in this file
        var cell = tableView.dequeueReusableCellWithIdentifier("StepListCell") as! StepListCell
        
        //setting styles of cell
        cell.checkmark.hidden = true
        cell.backgroundColor = lightBackgroundColor
        cell.stepTextLabel.textColor = darkTextColor
        cell.stepNumberLabel.textColor = darkTextColor
        cell.borderView.layer.borderColor = borderColor.CGColor
        cell.borderView.layer.borderWidth = 1
        
//        checked = [Bool](count: steps.count, repeatedValue: false)

        
        //set up check marks on completed tasks
        if checked.count > 0 {
            if checked[indexPath.row] {
                cell.checkmark.hidden = false
                cell.stepNumberLabel.hidden = true
                cell.backgroundColor = darkBackgroundColor
            } else {
                cell.checkmark.hidden = true
                cell.stepNumberLabel.hidden = false
            }
        }
        
        //adjusting for border on last item in list
        if indexPath.row == steps.count - 1 {
            cell.borderView.frame.size.height = 57
        }
        
        //setting proper numbering to left of steps
        cell.stepTextLabel.text = steps[indexPath.row]
        cell.stepNumberLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "stepDetailsIncompleteSegue" {
            
            let destinationViewController = segue.destinationViewController as! Item2ViewController
            destinationViewController.stepObject = self.stepObject
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            
        } else if segue.identifier == "stepDetailsCompleteSegue" {
            
            let destinationViewController = segue.destinationViewController as! Item1ViewController
            destinationViewController.stepObject = self.stepObject
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            
        } else {
            
            let destinationViewController = segue.destinationViewController
            
        }
    }

}

