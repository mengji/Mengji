//
//  boardController.swift
//  Instagram
//
//  Created by Xiangrui on 3/1/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

class boardController: UITableViewController {

    var titles = [String]()
    var usernames = [String]()
    var images = [UIImage]()
    var pffile = [PFFile]()
    var refresher:UIRefreshControl!
    
    //logout
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    //update other users' post information from server
    func update(){
        titles = [String]()
        pffile = [PFFile]()
        usernames = [String]()
        
        //find users which current user followed
        var getFollowingQuery = PFQuery(className: "followers")
        getFollowingQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
        getFollowingQuery.findObjectsInBackgroundWithBlock({
            (objects:[AnyObject]!,error:NSError!) in
            if (error == nil){
                var followedUser = ""
                for object in objects{
                    followedUser = object["following"] as String
                    //find followed users' post
                    var query = PFQuery(className: "postImage")
                    query.whereKey("name", equalTo: followedUser)
                    query.findObjectsInBackgroundWithBlock({
                        (objects:[AnyObject]!, error:NSError!) in
                        if (error == nil){
                            for object in objects{
                                self.titles.append(object["Title"] as String)
                                self.usernames.append(object["name"] as String)
                                self.pffile.append(object["imageFile"] as PFFile)
                                self.tableView.reloadData()
                            }
                        } else {
                            
                        }
                    })
                }
            }
            self.refresher.endRefreshing()
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myCell: cell =  self.tableView.dequeueReusableCellWithIdentifier("myCell") as cell
        //add image and text to every cell
        if (usernames.count > 0){
            myCell.myText?.text = usernames[indexPath.row] + ": " + titles[indexPath.row]
            //load image from pffile
            pffile[indexPath.row].getDataInBackgroundWithBlock({
                (imageData:NSData!,error:NSError!) in
                if (error == nil){
                    let image = UIImage(data:imageData)
                    myCell.postedImage.image = image
                }
            })
        }

        return myCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 280
    }
    
    
    
        
    
}
