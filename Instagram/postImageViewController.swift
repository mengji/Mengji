//
//  postImageViewController.swift
//  Instagram
//
//  Created by Xiangrui on 3/1/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

class postImageViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    var photoSeleted:Bool = false
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoSeleted = false
        imageToPost.image = UIImage(named: "placeholder_png.jpg")
        text.text = ""
        
    }
    

    
    @IBOutlet var imageToPost: UIImageView!
    
    //control submit button
    @IBAction func submit(sender: AnyObject) {
        var error = ""
        //check if a photo is seleted
        if (photoSeleted == false){
            error = "Please select an image to post"
        } else if(text.text == "") {
            error = "Please enter a message"
        }
        
        if (error != ""){
            displayAlert("Cannot post the image", error: error)
        } else {
            /*add activity indicator to view. It works when users upload an image and starts
            ignoring other action until uploading finished*/
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            //upload posted image
            var post = PFObject(className: "postImage")
            post["Title"] = text.text
            post["name"] = PFUser.currentUser().username
            post.saveInBackgroundWithBlock({
                (success:Bool!, error:NSError!) in
                if success == false {
                    self.displayAlert("Could not post image", error: "Please try again")
                } else {
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image)
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    post["imageFile"] = imageFile
                    post.saveInBackgroundWithBlock({
                        (success:Bool!, error:NSError!) in
                        //upload finished, starts accepting action
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        if (success == false){
                            self.displayAlert("Could not post image", error: "Please try again")
                        } else {
                            self.displayAlert("Success", error: "")
                            self.photoSeleted = false
                            self.imageToPost.image = UIImage(named: "placeholder_png.jpg")
                            self.text.text = ""                        }
                    })
                 }
                
            })
        }
        
        
    }
    @IBOutlet var text: UITextField!
    
    //choose an image from photolibrary
    @IBAction func chooseImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    //pick the image and show it in image view
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image
        photoSeleted = true
        
    }
    
    //display message to user in a new window
    func displayAlert(title:String, error:String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            action in
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
