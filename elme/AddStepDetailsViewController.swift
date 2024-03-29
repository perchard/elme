//
//  AddStepsViewController.swift
//  elme
//
//  Created by Sai Perchard on 10/31/15.
//  Copyright © 2015 maggled. All rights reserved.
//

import UIKit
import Parse

class AddStepDetailsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var distressSlider: GradientSlider!
    @IBOutlet weak var distressLevelLabel: UILabel!
    @IBOutlet weak var howDistressingLabel: UILabel!
    @IBOutlet weak var distressLevelView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stepTitle: UILabel!
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var rememberTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    let stepData = StepData.sharedInstance
    let user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = lightBackgroundColor
        
        howDistressingLabel.textColor = mediumTextColor
        distressLevelLabel.textColor = mediumSecondaryTextColor
        distressLevelView.backgroundColor = lightBackgroundColor
        distressLevelView.layer.borderWidth = 1
        distressLevelView.layer.borderColor = borderColor.CGColor
        distressSlider.maxColor = scale0
        distressSlider.minColor = scale0
        distressLevelLabel.text = "Peace, serenity, total relief. No more anxiety of any kind about any particular issue."
        
        distressSlider.thickness = 5.0
        distressSlider.thumbSize = 40.0
        
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = borderColor.CGColor
        
        previousButton.layer.borderWidth = 1.0
        previousButton.layer.borderColor = borderColor.CGColor
        
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = borderColor.CGColor
        containerView.layer.cornerRadius = 2.0
        
        if (self.stepData.stepIndex == nil) {
            self.stepData.stepIndex = 0
        }
        
        let currentStep = self.stepData.steps[self.stepData.stepIndex]
        
        let currentStepIndex = currentStep["step_index"] as! Int
        let currentStepDescription = currentStep["description"] as! String
        stepTitle.text = currentStepDescription
        stepNumber.text = "Step \(currentStepIndex + 1) of \(self.stepData.steps.count)"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        rememberTextView.textColor = placeholderTextColor
        rememberTextView.text = "Remember..."
        rememberTextView.delegate = self
        rememberTextView.returnKeyType = UIReturnKeyType.Done
        
        dateTextField.textColor = placeholderTextColor
        dateTextField.text = "Remind me on..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func distressSliderChanged(sender: GradientSlider) {
        
        if sender.value < 9 {
            distressSlider.maxColor = scale0
            distressSlider.minColor = scale0
            distressLevelLabel.text = "Peace, serenity, total relief. No more anxiety of any kind about any particular issue."
        } else if sender.value >= 9 && sender.value < 18 {
            distressSlider.maxColor = scale1
            distressSlider.minColor = scale1
            distressLevelLabel.text = "No acute distress and feeling basically good. If you took special effort you might feel something unpleasant but not much."
        } else if sender.value >= 18 && sender.value < 27 {
            distressSlider.maxColor = scale2
            distressSlider.minColor = scale2
            distressLevelLabel.text = "A little bit upset, but not noticeable unless you took care to pay attention to your feelings and then realize, 'yes' there is something bothering me."
        } else if sender.value >= 27 && sender.value < 36 {
            distressLevelLabel.text = "Mildly upset. Worried, bothered to the point that you notice it."
            distressSlider.maxColor = scale3
            distressSlider.minColor = scale3
        } else if sender.value >= 36 && sender.value < 45 {
            distressLevelLabel.text = "Somewhat upset to the point that you cannot easily ignore an unpleasant thought. You can handle it OK but don't feel good."
            distressSlider.maxColor = scale4
            distressSlider.minColor = scale4
        } else if sender.value >= 45 && sender.value < 54 {
            distressLevelLabel.text = "Moderately upset, uncomfortable. Unpleasant feelings are still manageable with some effort."
            distressSlider.maxColor = scale5
            distressSlider.minColor = scale5
        } else if sender.value >= 54 && sender.value < 63 {
            distressLevelLabel.text = "Feeling bad to the point that you begin to think something ought to be done about the way you feel."
            distressSlider.maxColor = scale6
            distressSlider.minColor = scale6
        } else if sender.value >= 63 && sender.value < 72 {
            distressLevelLabel.text = "Starting to freak out, on the edge of some definitely bad feelings. You can maintain control with difficulty."
            distressSlider.maxColor = scale7
            distressSlider.minColor = scale7
        } else if sender.value >= 72 && sender.value < 81 {
            distressLevelLabel.text = "Freaking out. The beginning of alienation."
            distressSlider.maxColor = scale8
            distressSlider.minColor = scale8
        } else if sender.value >= 81 && sender.value < 90 {
            distressLevelLabel.text = "Feeling desperate. Feeling extremely freaked out to the point that it almost feels unbearable and you are getting scared of what you might do."
            distressSlider.maxColor = scale9
            distressSlider.minColor = scale9
        } else {
            UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                self.distressLevelLabel.text = "Feeling bad to the point that you begin to think something ought to be done about the way you feel."
                }, completion: nil)
            distressSlider.maxColor = scale10
            distressSlider.minColor = scale10
        }
        
    }
    
    @IBAction func previousButton(sender: UIButton) {
        navigationController!.popViewControllerAnimated(true)
        
        // decrement stepIndex unless we're on step 1 (i.e. it's 0)
        if (self.stepData.stepIndex > 0) {
            self.stepData.stepIndex = self.stepData.stepIndex - 1
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        // update dictionary with step detail values specified in presenting view controller
        let currentStep = self.stepData.steps[self.stepData.stepIndex]
        currentStep.setObject(distressSlider.value, forKey: "distress_expected")
        currentStep.setObject(rememberTextView.text, forKey: "remember")
        currentStep.setObject(dateTextField.text!, forKey: "reminder_date")
        
        // If we're on the last step detail screen, open the 'next step' home screen
        if (self.stepData.stepIndex == (self.stepData.steps.count-1)) {
            
            // save everything to parse first
            let goal = PFObject(className:"Goal")
            goal["user"] = user
            goal["fear_description"] = self.stepData.fearDescription
            goal["achievement_description"] = self.stepData.achievementDescription
            // TODO: explicitly set permissions rather than relying on global setting
            //goal.ACL = PFACL(user: user!)
            goal.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("saved goal")
                    for (index, stepDict) in self.stepData.steps.enumerate() {
                        let step = PFObject(className:"Step")
                        step["user"] = self.user
                        step["goal"] = goal
                        step["description"] = stepDict["description"]
                        step["distress_expected"] = stepDict["distress_expected"]
                        step["remember"] = stepDict["remember"]
                        
                        // save as actual date in parse by casting to NSDate
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                        let date = dateFormatter.dateFromString(stepDict["reminder_date"] as! String)
                        step["reminder_date"] = date
                        
                        step.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                print("saved step")
                                // segue to 'next step' home screen on successful save of the last step
                                if (index == (self.stepData.steps.count-1)) {
                                    self.segueToLastStepDetail()
                                }
                            } else {
                                print(error!.description)
                            }
                        }
                    }
                } else {
                    print(error!.description)
                }
            }
            
            return false
            
            
        } else {
            self.stepData.stepIndex = self.stepData.stepIndex + 1
            return true
        }
    }
    
    func segueToLastStepDetail() {
        performSegueWithIdentifier("lastStepDetailSegue", sender: self)
    }

    @IBAction func nextButton(sender: UIButton) {
        
    }
    
    @IBAction func editDate(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func remindEndEdit(sender: UITextField) {
        if (dateTextField.text == "Remind me on...") {
            dateTextField.textColor = placeholderTextColor
        } else {
            dateTextField.textColor = darkTextColor
        }
    }
    
    func textViewDidBeginEditing(rememberTextView: UITextView) {
        if rememberTextView.textColor == placeholderTextColor {
            rememberTextView.text = nil
            rememberTextView.textColor = darkTextColor
        }
    }
    
    func textViewDidEndEditing(rememberTextView: UITextView) {
        if rememberTextView.text.isEmpty {
            rememberTextView.text = "Remember..."
            rememberTextView.textColor = placeholderTextColor
        }
    }
    
    // http://stackoverflow.com/questions/703754/how-to-dismiss-keyboard-for-uitextview-with-return-key
    func textView(rememberTextView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            dismissKeyboard()
        }
        return true
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
