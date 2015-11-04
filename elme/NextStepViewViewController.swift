//
//  NextStepViewViewController.swift
//  elme
//
//  Created by Prime, Heather(AWF) on 10/31/15.
//  Copyright © 2015 maggled. All rights reserved.
//

import UIKit

class NextStepViewViewController: UIViewController {


    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var testExpand: UIView!
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var navBarView: UIImageView!
    @IBOutlet weak var hamburgerButton: UIButton!
    
    var hamburgerViewController: HamburgerViewController!
    var isMenuOpen = false
    
    var newGoalTransition: NewGoalTransition!
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = darkBackgroundColor
        stepLabel.textColor = darkTextColor
        dateLabel.textColor = darkSecondaryTextColor
        
        testExpand.backgroundColor = lightBackgroundColor
        testExpand.layer.borderColor = borderColor.CGColor
        testExpand.layer.borderWidth = 1.0
        testExpand.layer.cornerRadius = testExpand.frame.size.width/2
        testExpand.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var onCheckmarkTap: UIButton!
    
    @IBAction func onMenuTap(sender: AnyObject) {
        if (isMenuOpen == false) {
            hamburgerViewController.openMenu()
            isMenuOpen = true
        } else {
            hamburgerViewController.closeMenu()
            isMenuOpen = false
        }
    }
    
    @IBAction func onRightChevronTap(sender: AnyObject) {
    }
    

    @IBAction func onLongPress(sender: UILongPressGestureRecognizer) {
    
        switch sender.state
        {
        case .Began:
            print("began press")
        case .Changed:
            print("changed press")

            if counter > 20 {
                performSegueWithIdentifier("CompleteQuestionStep", sender: self)
                delay(1) {
                    self.testExpand.transform = CGAffineTransformMakeScale(1, 1)
                    self.counter = 0
                }
            } else {
                counter = counter + 1
                print(counter)
                var checkmarkScaleX = convertValue(CGFloat(counter), r1Min: 0, r1Max: 80, r2Min: 1, r2Max: 2)

                print(checkmarkScaleX)
                testExpand.transform = CGAffineTransformScale(self.testExpand.transform, CGFloat(checkmarkScaleX), CGFloat(checkmarkScaleX))
                
                
            }


        case .Ended:
            print("end press")
                        default: ()
                        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
                            self.testExpand.transform = CGAffineTransformMakeScale(1, 1)
                            
                            }, completion: nil)
                        counter = 0
        }
    }
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationViewController = segue.destinationViewController
        newGoalTransition = NewGoalTransition()
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = newGoalTransition
        //destinationViewController.presentViewController(self, animated: true, completion: nil)
        newGoalTransition.duration = 0.01
    }

    
}
