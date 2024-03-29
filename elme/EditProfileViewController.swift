//
//  EditProfileViewController.swift
//  elme
//
//  Created by Prime, Heather(AWF) on 10/26/15.
//  Copyright © 2015 maggled. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var onBackButton: UIButton!
    @IBOutlet weak var smokeScreen: UIView!
    
    var email: [String]!
    var name: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.currentUser()
        let email = user!.username
        emailField.text = email
        
        let name = user!["fullName"] as? String
        nameField.text = name
        
        
       /*
        
        var query = PFQuery(className:"email")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && self.email != nil {
                print(self.email)
            } else {
                print(error)
        }
        }
        */
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //DELAY THING
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    //SIGN IN
    @IBAction func onSignIn(sender: AnyObject) {
        
        //SUCCESS
        if emailField.text == "" || passwordField.text == "" || nameField.text == "" {
            
            //SPINNER
            self.smokeScreen.hidden = false
            print("smoke", terminator: "")
            
            //DELAY
            delay(1){
                //self.performSegueWithIdentifier("editProfileSegue", sender: nil)
               // self.navigationController!.popViewControllerAnimated(true)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }

    }
    
    //BACK BUTTON

    @IBAction func onBackButton(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
    }
   
   

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
