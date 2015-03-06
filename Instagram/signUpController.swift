//
//  signUpController.swift
//  Instagram
//
//  Created by Xiangrui on 2/28/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIkit

class signUpController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var lastname: UITextField!
    @IBOutlet var password: UITextField!
    
    func displayAlert(title:String,error:String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            action in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func submit(sender: AnyObject) {
        var error = ""
        
        
        if (username.text == "" || firstname.text == ""||lastname.text == "" || password.text == ""){
            error = "Plase fill the form"
        }
        if error != "" {
            
            displayAlert("Plase fill the form", error: error)
            
        } else {
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            user.setValue(firstname.text, forKey: "firstname")
            user.setValue(lastname.text, forKey: "lastname")
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            user.signUpInBackgroundWithBlock({
                (succeeded,signUpError) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if signUpError == nil {
                    self.performSegueWithIdentifier("jumpToMain",sender: self)
                } else {
                    if let errorString = signUpError.userInfo?["error"] as? NSString{
                        error = errorString
                    } else {
                        error = "Please try again later"
                    }
                    self.displayAlert("Could Not Sign Up", error: error)
                    
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
