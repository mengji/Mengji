//
//  ViewController.swift
//  Instagram
//
//  Created by Xiangrui on 2/28/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

<<<<<<< HEAD
class ViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func displayAlert(title:String, error:String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            action in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }


    @IBAction func loginButt(sender: AnyObject) {
        var error = ""
        
        if (usernameText.text == "" || passwordText.text == ""){
            error = "Please enter username and password"
            
        }
        if error != "" {
            displayAlert("Error", error: error)
            
        } else {
            PFUser.logInWithUsernameInBackground(usernameText.text, password:passwordText.text) {
                (user: PFUser!, loginerror: NSError!) -> Void in
                if loginerror == nil {
                    self.performSegueWithIdentifier("jumpToMain",sender: self)
                    
                } else {
                    if let errorString = loginerror.userInfo?["error"] as? NSString{
                        error = errorString
                    } else{
                        error = "please try agian later"
                    }
                    self.displayAlert("Error", error: error)
                }
            }
            
            
        }
        
    }
 
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
=======
class ViewController: UIViewController {
>>>>>>> parent of 2c01c5b... Mengji

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

