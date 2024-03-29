//
//  Hamburger2ViewController.swift
//  
//
//  Created by Prime, Heather(AWF) on 10/31/15.
//
//

import UIKit

class Hamburger2ViewController: UIViewController {

    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var initialCenter: CGPoint!
    
    var menuViewController: UIViewController!
    var homeViewController: UIViewController!
    
    // viewControllers = [homeViewController, menuViewController]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController")
        homeViewController = storyboard.instantiateViewControllerWithIdentifier("TestingViewController")
        
        // Do any additional setup after loading the view.
        
        homeViewController.view.frame = contentView.frame
        contentView.addSubview(homeViewController.view)
        
        menuViewController.view.frame = menuView.frame
        menuView.addSubview(menuViewController.view)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let location = sender.locationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            initialCenter = contentView.center
            
        } else if sender.state == UIGestureRecognizerState.Changed{
            
            if velocity.x > 0 {
                contentView.center = CGPoint(x: translation.x + initialCenter.x, y:initialCenter.y)
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended{
            UIView.animateWithDuration(0.8, animations: { () -> Void in
                if velocity.x < 0 {
                    self.contentView.center = self.view.center
                    
                } else{
                    self.contentView.center = CGPoint(x: self.view.center.x + 280, y: self.view.center.y)
                    
                }
                
            })
            
            
        }
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

